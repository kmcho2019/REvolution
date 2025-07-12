module TopModule(
    input  logic clk,
    input  logic reset,
    output logic shift_ena
);

    // Define states
    enum logic [1:0] {IDLE_STATE, RESET_STATE} state, next_state;

    logic [1:0] counter; // counter to keep track of the number of clock cycles

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= RESET_STATE;
            counter <= 2'd3;
        end else begin
            state <= next_state;
            if (state == RESET_STATE) begin
                if (counter > 0) begin
                    counter <= counter - 1'b1;
                end
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            RESET_STATE: begin
                if (counter == 0) begin
                    next_state = IDLE_STATE;
                end
            end
            IDLE_STATE: begin
                // Stay in IDLE_STATE
            end
        endcase
    end

    always_comb begin
        case (state)
            RESET_STATE: shift_ena = 1'b1;
            IDLE_STATE: shift_ena = 1'b0;
        endcase
    end

endmodule