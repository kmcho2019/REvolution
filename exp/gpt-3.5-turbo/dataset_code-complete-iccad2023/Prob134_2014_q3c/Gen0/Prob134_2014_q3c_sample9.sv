module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

// Define the next state logic based on the state-assigned table
always @(*)
begin
  case({y, x})
    3'b0000: Y0 = 1'b0;  // Next state Y[0] when x=0
    3'b0001: Y0 = 1'b0;  // Next state Y[0] when x=1
    3'b0010: Y0 = 1'b0;
    3'b0011: Y0 = 1'b0;
    3'b0100: Y0 = 1'b0;
    3'b0101: Y0 = 1'b1;
    3'b0110: Y0 = 1'b0; 
    3'b0111: Y0 = 1'b0;
    3'b1000: Y0 = 1'b1;
    3'b1001: Y0 = 1'b0;
    3'b1010: Y0 = 1'b0;
    3'b1011: Y0 = 1'b1;
    3'b1100: Y0 = 1'b1;
    3'b1101: Y0 = 1'b1;
    3'b1110: Y0 = 1'b0;
    3'b1111: Y0 = 1'b0;
  endcase
end

// Output z logic based on the state-assigned table
always @(*)
begin
  case({y, x})
    3'b0011: z = 1'b1;  // Output z value for the given state
    3'b1000: z = 1'b1;  // Output z value for the given state
    default: z = 1'b0;   // Default output z value
  endcase
end

endmodule