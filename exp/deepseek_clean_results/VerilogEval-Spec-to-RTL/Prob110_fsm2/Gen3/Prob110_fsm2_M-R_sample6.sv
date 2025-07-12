module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State definition using enumerated type
    typedef enum logic {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;
    
    state_t current_state, next_state;

    // Combinational next state logic
    always_comb begin
        case (current_state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential state register with async reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

    // Output logic (Moore machine)
    assign out = (current_state == ON);

endmodule