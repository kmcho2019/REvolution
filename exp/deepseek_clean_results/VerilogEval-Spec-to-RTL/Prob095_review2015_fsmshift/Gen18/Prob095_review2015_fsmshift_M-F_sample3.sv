module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    typedef enum logic [2:0] {
        INIT,
        CYCLE1,
        CYCLE2,
        CYCLE3,
        CYCLE4,
        DONE
    } state_t;

    state_t current_state;

    assign shift_ena = (current_state == CYCLE1) || 
                       (current_state == CYCLE2) ||
                       (current_state == CYCLE3) ||
                       (current_state == CYCLE4);

    always @(posedge clk) begin
        if (reset) begin
            current_state <= INIT;
        end else begin
            case (current_state)
                INIT:   current_state <= CYCLE1;
                CYCLE1: current_state <= CYCLE2;
                CYCLE2: current_state <= CYCLE3;
                CYCLE3: current_state <= CYCLE4;
                CYCLE4: current_state <= DONE;
                DONE:   current_state <= DONE;
                default: current_state <= INIT;
            endcase
        end
    end

endmodule