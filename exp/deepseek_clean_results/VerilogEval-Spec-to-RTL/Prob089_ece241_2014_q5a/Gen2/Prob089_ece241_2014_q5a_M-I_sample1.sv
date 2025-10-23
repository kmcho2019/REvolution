module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    typedef enum logic {PASS, INVERT} state_t;
    state_t state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            PASS: begin
                z = x;
                next_state = x ? INVERT : PASS;
            end
            INVERT: begin
                z = ~x;
                next_state = INVERT;
            end
        endcase
    end

endmodule