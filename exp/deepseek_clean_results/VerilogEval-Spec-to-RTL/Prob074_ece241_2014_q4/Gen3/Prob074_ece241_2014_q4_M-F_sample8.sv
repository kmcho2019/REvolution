module TopModule (
    input clk,
    input x,
    output z
);

    // Separate state registers for each path
    reg xor_state, and_state, or_state;
    
    // Combinational logic for next state
    wire next_xor = x ^ xor_state;
    wire next_and = x & ~and_state;
    wire next_or = x | ~or_state;
    
    // State update with synchronous reset
    always @(posedge clk) begin
        xor_state <= next_xor;
        and_state <= next_and;
        or_state <= next_or;
    end
    
    // Output is NOR of all state bits
    assign z = ~(xor_state | and_state | or_state);
    
    // Initial state (for simulation)
    initial begin
        xor_state = 1'b0;
        and_state = 1'b0;
        or_state = 1'b0;
    end

endmodule