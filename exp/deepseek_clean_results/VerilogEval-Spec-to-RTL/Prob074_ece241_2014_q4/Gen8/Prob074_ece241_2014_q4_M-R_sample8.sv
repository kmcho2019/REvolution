module TopModule (
    input clk,
    input x,
    output z
);

    // State registers
    reg xor_state, and_state, or_state;
    
    // Combinational logic
    wire xor_in = x ^ xor_state;
    wire and_in = x & ~and_state;
    wire or_in = x | ~or_state;
    
    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        xor_state <= xor_in;
        and_state <= and_in;
        or_state <= or_in;
    end
    
    // Output logic
    assign z = ~(xor_state | and_state | or_state);

    // Initialization (for simulation only)
    initial begin
        xor_state = 0;
        and_state = 0;
        or_state = 0;
    end

endmodule