module TopModule (
  input [255:0] in,
  input [7:0] sel,
  output  out
);

reg out;

always @(*) begin
    case(sel)
        8'b00000000: out = in[0];
        8'b00000001: out = in[1];
        8'b00000010: out = in[2];
        // Add more cases for the remaining inputs
        // ...
        default: out = 1'b0; // Default case if sel is out of range
    endcase
end

endmodule