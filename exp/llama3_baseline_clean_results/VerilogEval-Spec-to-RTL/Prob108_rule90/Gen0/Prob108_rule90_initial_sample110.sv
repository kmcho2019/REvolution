module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to hold the state of cells
assign q = q_reg;  // Continuous assignment to output

// Rule 90 implementation
always @(posedge clk) begin
    if (load) begin
        // Load data into the register on the positive edge of the clock
        q_reg <= data;
    end else begin
        // Initialize next state
        reg [511:0] next_state;
        
        // Apply Rule 90 to update the next state of each cell
        next_state[0] <= q_reg[0] ^ q_reg[1]; // Left boundary is always 0
        next_state[511] <= q_reg[510] ^ q_reg[511]; // Right boundary is always 0
        for (genvar i = 1; i < 511; i++) begin
            next_state[i] <= q_reg[i-1] ^ q_reg[i+1];
        end
        
        // Update the state register
        q_reg <= next_state;
    end
end

endmodule