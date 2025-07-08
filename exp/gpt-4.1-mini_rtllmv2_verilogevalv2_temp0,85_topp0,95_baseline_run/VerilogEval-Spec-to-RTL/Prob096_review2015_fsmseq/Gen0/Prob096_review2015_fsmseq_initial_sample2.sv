module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding for sequence detection of "1101"
    typedef enum reg [2:0] {
        IDLE = 3'b000,       // no match yet
        S1 = 3'b001,         // matched '1'
        S11 = 3'b010,        // matched "11"
        S110 = 3'b011,       // matched "110"
        FOUND = 3'b100       // sequence found, start_shifting = 1
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case(current_state)
            IDLE: begin
                if (data == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end
            S1: begin
                if (data == 1'b1)
                    next_state = S11;
                else
                    next_state = IDLE;
            end
            S11: begin
                if (data == 1'b0)
                    next_state = S110;
                else
                    next_state = S11; // stay here if input is 1 (because "11" repeated)
            end
            S110: begin
                if (data == 1'b1)
                    next_state = FOUND;
                else if (data == 1'b0)
                    next_state = IDLE;
                else
                    next_state = IDLE;
            end
            FOUND: begin
                next_state = FOUND; // stay in found state forever
            end
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            if (next_state == FOUND)
                start_shifting <= 1'b1;
        end
    end

endmodule