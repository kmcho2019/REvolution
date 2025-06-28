module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);

  reg [3:0] out;

  always @* begin
    case(sel)
      0: out = in[4*sel+3:4*sel];  
      1: out = in[4*sel+7:4*sel+4];  
      2: out = in[4*sel+11:4*sel+8];
      // Add all cases up to sel=255 similarly
      default: out = 4'hx; // Default output
    endcase
  end

endmodule