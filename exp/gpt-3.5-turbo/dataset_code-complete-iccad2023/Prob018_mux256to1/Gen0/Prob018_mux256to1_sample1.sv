module TopModule (
  input [255:0] in,
  input [7:0] sel,
  output reg out
);

always @* begin
    case(sel)
        8'b00000000: out = in[0];
        8'b00000001: out = in[1];
        // Continue this pattern until sel = 255
        // For example, if all inputs should be the same, you could simply use:
        // default: out = in[0]; 
    endcase
end

endmodule