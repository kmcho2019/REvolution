module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the XOR of the bits at the tap positions
        reg xor_result = q[31] ^ q[22] ^ q[2] ^ q[1];
        
        // Shift the entire 32-bit register to the right and update the most significant bit
        next_q = {xor_result, q[31:1]};
        
        // Update the output 'q'
        q <= next_q;
    end
end

endmodule