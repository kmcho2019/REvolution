module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk = 0
);

    // Define states for the FSM
    typedef enum {LOW, HIGH} state_t;
    state_t current_state = LOW;

    // Half period delay (converted to time units)
    localparam HALF_PERIOD = PERIOD / 2;

    // Clock generation state machine
    always begin
        case (current_state)
            LOW: begin
                #HALF_PERIOD;
                clk <= 1'b1;
                current_state <= HIGH;
            end
            HIGH: begin
                #HALF_PERIOD;
                clk <= 1'b0;
                current_state <= LOW;
            end
        endcase
    end

endmodule