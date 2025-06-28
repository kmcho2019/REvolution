module TopModule (
  input [255:0] in,
  input [7:0] sel,
  output reg out
);

always @* begin
    case(sel)
        8'b00000000: out = in[0];
        8'b00000001: out = in[1];
        // Add more cases for other inputs
        default: out = 1'b0; // default output value
    endcase
end

endmodule