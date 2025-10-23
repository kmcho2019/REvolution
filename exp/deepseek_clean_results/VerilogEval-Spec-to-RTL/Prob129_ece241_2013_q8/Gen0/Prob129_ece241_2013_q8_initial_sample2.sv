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

    // State transition and output logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        // Default assignments
        next_state = current_state;
        z = 1'b0;

        case (current_state)
            IDLE: begin
                if (x) next_state = GOT1;
            end
            GOT1: begin
                if (!x) next_state = GOT10;
            end
            GOT10: begin
                if (x) begin
                    z = 1'b1;
                    next_state = GOT1;  // Allow overlapping sequences
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule