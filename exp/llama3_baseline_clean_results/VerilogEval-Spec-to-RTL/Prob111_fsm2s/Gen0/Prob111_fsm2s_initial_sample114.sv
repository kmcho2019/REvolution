module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // Define the states
    typedef enum logic [0:0] {OFF, ON} state_t;
    reg state_t current_state, next_state;

    // Initialize the state machine
    initial current_state = OFF;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            OFF: begin
                if (j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if (k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule