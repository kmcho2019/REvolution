module TopModule(
    input [7:0] in,
    output reg [31:0] out
);

always @(*) begin
    out = {{24{in[7]}}, in}; // Replicate the sign bit 24 times and concatenate with the 8-bit number
end

endmodule