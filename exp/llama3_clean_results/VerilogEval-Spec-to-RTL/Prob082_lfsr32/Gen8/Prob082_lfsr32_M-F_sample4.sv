module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        // Initialize next_q by shifting q one bit to the right
        next_q = {1'b0, q[31:1]};
        
        // Calculate the new MSB based on the taps and the current LSB
        next_q[31] = q[31] ^ q[21] ^ q[1] ^ q[0];
        
        // Update q with the next state, but first we shift right, so we use the calculation directly
        q <= {q[31] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
    end
end

endmodule