module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        // Load the input data into the register
        q_reg <= data;
    end else begin
        // Update the register based on the rules of the automaton
        reg [511:0] next_state; // Temporary register to store the next state
        // Explicitly handle each cell's next state to reduce combinational logic depth
        next_state[0] <= q_reg[0] ^ q_reg[1]; // Left boundary condition
        next_state[511] <= q_reg[510] ^ q_reg[511]; // Right boundary condition
        // Use a more parallelized approach for the middle cells
        for (int i = 1; i < 511; i++) begin
            next_state[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
        q_reg <= next_state; // Update the register with the next state
    end
end

assign q = q_reg; // Output the current state

endmodule