module TopModule (
  input [4:1] x,
  output logic f
);
  
  assign f = 
    ((x == 4'b0001) | (x == 4'b0101) | (x == 4'b1100) | (x == 4'b1101)) ? 0 : // Specific input combinations with output 0
    ((x == 4'b0111) | (x == 4'b1011) | (x == 4'b1110) | (x == 4'b1111)) ? 1 : // Specific input combinations with output 1
    (x == 4'b0000) ? 1 : // Specific input combination with output 1
    (x == 4'b0010) ? 1 : // Specific input combination with output 1
    default: 0; // Default output value for other input combinations
  
endmodule