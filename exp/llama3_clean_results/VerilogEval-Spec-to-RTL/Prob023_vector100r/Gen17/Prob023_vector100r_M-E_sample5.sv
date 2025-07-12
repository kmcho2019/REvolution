module TopModule(
    input [99:0] in,
    output reg [99:0] out
);

// Divide the input into two 50-bit chunks and swap them
always @(*) begin
    out[99:50] = in[49:0];
    out[49:0] = in[99:50];
end

endmodule