module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the next state of the most significant bit
        next_state[31] <= q[22] ^ q[2] ^ q[1] ^ q[0];
        
        // Shift the rest of the bits to the right
        for (int i = 30; i > 0; i--) begin
            if (i == 21) begin
                // Update the tap position 22
                next_state[i] <= q[i-1] ^ q[0];
            end else if (i == 1) begin
                // Update the tap position 2
                next_state[i] <= q[i-1] ^ q[0];
            end else if (i == 0) begin
                // Update the tap position 1
                next_state[i] <= q[i-1] ^ q[0];
            end else begin
                next_state[i] <= q[i-1];
            end
        end
        
        // Update the least significant bit
        next_state[0] <= q[31];
        
        // Update the current state
        q <= next_state;
    end
end

endmodule