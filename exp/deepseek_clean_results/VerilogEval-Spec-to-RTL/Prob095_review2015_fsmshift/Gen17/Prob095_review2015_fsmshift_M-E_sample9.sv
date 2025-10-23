module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    typedef enum logic [2:0] {
        RESET,
        CYCLE1,
        CYCLE2,
        CYCLE3,
        DONE
    } state_t;

    state_t current_state;

    assign shift_ena = (current_state != DONE);

    always @(posedge clk) begin
        if (reset) begin
            current_state <= RESET;
        end else begin
            case (current_state)
                RESET:  current_state <= CYCLE1;
                CYCLE1: current_state <= CYCLE2;
                CYCLE2: current_state <= CYCLE3;
                CYCLE3: current_state <= DONE;
                DONE:   current_state <= DONE;
                default: current_state <= DONE;
            endcase
        end
    end

endmodule