;Using Otsu method to calculate dynamic gray threshold
;Otsu algorithm is suitable for images with bimodal histogram.
PRO OTSU_Thresholding_modified
  compile_opt idl2
  envi, /restore_base_save_files
  envi_batch_init

  image_name =dialog_pickfile(title=' Open the file ')
  minThresh=-0.8
  maxThresh=0.8

  step=0.01
  maxxx=0.0

  envi_open_file,image_name,r_fid = fid_1
  envi_file_query, fid_1, ns=ns, nl=nl, nb=nb , dims = dims
  print,"dims:"+dims
  image_data = ENVI_GET_DATA(fid=fid_1, dims=dims, pos=[0])

  totalcount=ns*nl;The number of pixels of the input image
  for thresh=minThresh,maxThresh,step do begin
    backinx=where(image_data lt thresh, backcnt)
    if(backcnt eq 0) then continue
    w0=float(backcnt)/float(totalcount);w0:The proportion of the number of target pixels in the whole image
    w1=1-w0;w1:The proportion of background pixels to the whole image
    sum0=total(image_data[backinx])
    u0=float(sum0)/float(backcnt)
    sum1=total(image_data)-sum0
    u1=float(sum1)/float(totalcount-backcnt)
    g=w0*w1*(u0-u1)*(u0-u1);g is the inter class variance

    if (g gt maxxx)then begin
      maxxx=g
      T=thresh;The threshold of maximizing the variance between classes is obtained by traversal method
    endif
    print, string(thresh) + " " + string(g)
  endfor
  print,"T=",T
END