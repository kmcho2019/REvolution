module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output reg [3:0] out
);
  
  always @* begin
    case(sel)
      8'h00: out = in[3:0];
      8'h01: out = in[7:4];
      8'h02: out = in[11:8];
      // Add more cases for other ranges as needed
      default: out = 4'h0; // Default output if sel doesn't match any case
    endcase
  end

endmodule