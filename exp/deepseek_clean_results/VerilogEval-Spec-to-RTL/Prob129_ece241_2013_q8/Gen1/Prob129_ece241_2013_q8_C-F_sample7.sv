module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        GOT1,
        GOT10
    } state_t;

    // State registers
    state_t current_state, next_state;

    // Next state logic (combinational)
    always_comb begin
        case (current_state)
            IDLE: next_state = x ? GOT1 : IDLE;
            GOT1: next_state = x ? GOT1 : GOT10;
            GOT10: next_state = x ? GOT1 : IDLE;
        endcase
    end

    // State update and Mealy output (sequential)
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 0;
        end else begin
            current_state <= next_state;
            // Mealy output: check current state and input
            z <= (current_state == GOT10) && x;
        end
    end

endmodule