module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output reg [3:0] out
);

always @*
begin
    case(sel)
        8'h00: out = in[3:0];
        8'h01: out = in[7:4];
        8'h02: out = in[11:8];
        // Continue for all 256 cases
        default: out = 4'b0;
    endcase
end

endmodule