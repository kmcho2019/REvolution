module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = 
    ((y[6] & ~w) & (y[1])) | // Transition from A to B on w=0
    ((y[6] & ~w) & (y[5])) | // Transition from E to D on w=1
    ((y[2] & ~w) & (y[3]));   // Transition from C to E on w=0

assign Y4 = 
    ((y[6] & ~w) & (y[6])) | // Transition from A to A on w=0
    ((y[6] & ~w) & (y[3])) | // Transition from A to C on w=0
    ((y[6] & ~w) & (y[5])) | // Transition from A to E on w=1
    ((y[2] & ~w) & (y[6])) | // Transition from C to A on w=0
    ((y[2] & ~w) & (y[5])) | // Transition from C to E on w=1
    ((y[3] & ~w) & (y[5])) | // Transition from D to E on w=1