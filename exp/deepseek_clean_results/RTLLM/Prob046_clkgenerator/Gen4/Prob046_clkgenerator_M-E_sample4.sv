module clkgenerator #(parameter PERIOD = 10) (
    input sys_clk,    // High-frequency system clock reference
    input reset_n,   // Active-low reset
    output reg clk   // Generated clock output
);

    // States for the clock generator FSM
    typedef enum {CLK_LOW, CLK_HIGH} clk_state_t;
    clk_state_t state, next_state;
    
    // Counter for timing control
    localparam HALF_PERIOD = (PERIOD + 1) / 2;  // Round up for odd periods
    reg [$clog2(HALF_PERIOD+1)-1:0] counter;

    // State transition and counter logic
    always @(posedge sys_clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= CLK_LOW;
            counter <= 0;
            clk <= 1'b0;
        end
        else begin
            counter <= counter + 1;
            
            if (counter >= HALF_PERIOD-1) begin
                state <= next_state;
                counter <= 0;
                clk <= ~clk;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            CLK_LOW: next_state = CLK_HIGH;
            CLK_HIGH: next_state = CLK_LOW;
            default: next_state = CLK_LOW;
        endcase
    end

endmodule