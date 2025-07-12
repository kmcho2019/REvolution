`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,       // Clock period in ns
    parameter INIT_STATE = 0    // Initial clock state (0 or 1)
) (
    output reg clk              // Generated clock output
);

    localparam HALF_PERIOD = PERIOD / 2;
    localparam STATE_HIGH = 1'b1;
    localparam STATE_LOW = 1'b0;
    
    reg current_state;
    reg [31:0] timer;
    
    // Initialize clock and state
    initial begin
        clk = INIT_STATE;
        current_state = INIT_STATE ? STATE_HIGH : STATE_LOW;
        timer = 0;
    end
    
    always @(*) begin
        // State transition logic
        case (current_state)
            STATE_HIGH: if (timer >= HALF_PERIOD) current_state = STATE_LOW;
            STATE_LOW:  if (timer >= HALF_PERIOD) current_state = STATE_HIGH;
        endcase
    end
    
    // Timer and clock update
    always @(current_state) begin
        timer = 0;
        clk = current_state;
    end
    
    // Timer increment
    always begin
        #1;
        if (timer < PERIOD) timer = timer + 1;
    end

endmodule