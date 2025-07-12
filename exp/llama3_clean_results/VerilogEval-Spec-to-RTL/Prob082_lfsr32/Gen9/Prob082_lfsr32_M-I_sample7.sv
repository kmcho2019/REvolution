module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the XOR of the bits at the tap positions with the least significant bit
        reg xor_result;
        xor_result = q[22] ^ q[2] ^ q[1] ^ q[0];
        
        // Shift the LFSR to the right and fill the most significant bit with the result of the XOR operation
        q <= {xor_result, q[31:1]};
    end
end

endmodule