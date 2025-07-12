module fsm(
    input  logic IN,    // Input signal to the FSM
    input  logic CLK,   // Clock signal used for synchronous operation
    input  logic RST,   // Reset signal to initialize the FSM
    output logic MATCH  // Output signal indicating a match condition based on the FSM state
);

// Define states as parameters for better readability
parameter S0 = 4'd0,  // Initial state
           S1 = 4'd1,  // State after receiving '1'
           S2 = 4'd2,  // State after receiving '0' following '1'
           S3 = 4'd3,  // State after receiving '0' following '0'
           S4 = 4'd4,  // State after receiving '1' following '00'
           S5 = 4'd5;  // Final state after receiving '1' following '1'

// Current and next state variables
logic [3:0] current_state, next_state;

// Assign initial state
assign next_state = (RST)? S0 :
                    (current_state == S0 && IN)? S1 :
                    (current_state == S1 &&!IN)? S2 :
                    (current_state == S2 &&!IN)? S3 :
                    (current_state == S3 && IN)? S4 :
                    (current_state == S4 && IN)? S5 :
                    (current_state == S5)? ((IN)? S1 : S0) :  // Reset state after match
                    current_state;  // Stay in current state for other conditions

// Synchronous reset
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= S0;
        MATCH <= 1'b0;
    end else begin
        current_state <= next_state;
        MATCH <= (current_state == S5 && IN)? 1'b1 : 1'b0;
    end
end

endmodule