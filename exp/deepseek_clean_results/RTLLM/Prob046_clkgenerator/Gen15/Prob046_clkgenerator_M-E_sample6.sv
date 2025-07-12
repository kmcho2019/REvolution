module clkgenerator #(
    parameter PERIOD = 10       // Clock period in time units
)(
    output reg clk             // Generated clock output
);

    // Define FSM states
    typedef enum {CLK_LOW, CLK_HIGH} clk_state_t;
    clk_state_t state = CLK_LOW;

    // Calculate half period (rounded down for even division)
    localparam HALF_PERIOD = PERIOD / 2;

    // State transition logic
    always begin
        case (state)
            CLK_LOW: begin
                clk = 1'b0;
                #HALF_PERIOD;
                state = CLK_HIGH;
            end
            CLK_HIGH: begin
                clk = 1'b1;
                #HALF_PERIOD;
                state = CLK_LOW;
            end
        endcase
    end

    // Initial state assignment (redundant but good practice)
    initial begin
        clk = 1'b0;
        state = CLK_LOW;
    end

endmodule