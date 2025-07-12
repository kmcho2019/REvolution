module TopModule(
    input [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

always @(*) begin
    parity = ^in;  // Calculate parity using XOR reduction operator
end

endmodule