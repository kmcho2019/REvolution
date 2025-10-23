module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    // Define states
    typedef enum logic {
        IDLE,
        ACTIVE
    } state_t;

    // State and counter registers
    state_t state, next_state;
    reg [1:0] counter;

    // Output logic
    assign shift_ena = (state == ACTIVE);

    // State transition and counter logic
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            counter <= 2'b00;
        end else begin
            case (state)
                ACTIVE: begin
                    if (counter == 2'b11) begin
                        state <= IDLE;
                        counter <= 2'b00;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                IDLE: begin
                    // Stay in IDLE until reset
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule