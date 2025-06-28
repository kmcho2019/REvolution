module TopModule (
  input [3:0] x,
  output logic f
);

  // Define the function f using implication equations based on the Karnaugh map
  assign f = (x == 4'b0000) |        // x[1]=0, x[2]=0, x[3]=0, x[4]=0
             (x == 4'b0110) |        // x[1]=0, x[2]=1, x[3]=1, x[4]=0
             (x == 4'b0011) |        // x[1]=0, x[2]=0, x[3]=1, x[4]=1
             (x == 4'b0100) |        // x[1]=0, x[2]=1, x[3]=0, x[4]=0
             (x == 4'b0111);         // x[1]=0, x[2]=1, x[3]=1, x[4]=1

endmodule