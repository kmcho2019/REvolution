module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

assign q = q_reg; // Output the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        reg [511:0] next_state;
        
        // Handle boundary conditions
        next_state[0] = 1'b0 ^ q_reg[0] ^ q_reg[1]; // Leftmost cell, considering left neighbor as 0
        next_state[511] = q_reg[510] ^ q_reg[511] ^ 1'b0; // Rightmost cell, considering right neighbor as 0
        
        // Calculate next state for all other cells
        for (int i = 1; i < 511; i++) begin
            next_state[i] = q_reg[i-1] ^ q_reg[i] ^ q_reg[i+1]; // XOR with left, center, and right neighbors
        end
        
        q_reg <= next_state; // Update with calculated next states
    end
end

endmodule