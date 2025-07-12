module TopModule (
    input a,
    input b,
    output reg out
);
    // Define states for all input combinations
    typedef enum logic [1:0] {
        S_00 = 2'b00,
        S_01 = 2'b01,
        S_10 = 2'b10,
        S_11 = 2'b11
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic
    always_comb begin
        next_state = {a, b}; // Next state is simply current inputs
    end
    
    // Output logic - XNOR of state bits
    always_comb begin
        out = ~(current_state[1] ^ current_state[0]);
    end
    
    // State register
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end
    
    // Clock generation (for simulation only)
    reg clk = 0;
    always #5 clk = ~clk;
endmodule