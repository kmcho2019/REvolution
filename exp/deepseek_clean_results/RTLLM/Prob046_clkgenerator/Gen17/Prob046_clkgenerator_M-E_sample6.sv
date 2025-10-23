`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock output
);

    // FSM states
    typedef enum {IDLE, WAIT_HIGH, WAIT_LOW} state_t;
    state_t current_state = IDLE;
    
    // Timing control
    reg [31:0] elapsed_time = 0;
    localparam HALF_PERIOD = PERIOD / 2;
    
    // Soft start control
    reg initialized = 0;
    
    // Main state machine
    always begin
        case (current_state)
            IDLE: begin
                clk <= 0;
                elapsed_time <= 0;
                if (initialized) begin
                    current_state <= WAIT_HIGH;
                end else begin
                    #1 initialized <= 1;
                end
            end
            
            WAIT_HIGH: begin
                #1 elapsed_time <= elapsed_time + 1;
                if (elapsed_time >= HALF_PERIOD - 1) begin
                    clk <= 1;
                    elapsed_time <= 0;
                    current_state <= WAIT_LOW;
                end
            end
            
            WAIT_LOW: begin
                #1 elapsed_time <= elapsed_time + 1;
                if (elapsed_time >= HALF_PERIOD - 1) begin
                    clk <= 0;
                    elapsed_time <= 0;
                    current_state <= WAIT_HIGH;
                end
            end
        endcase
    end
    
    // Reset control (synthesis-friendly)
    initial begin
        current_state <= IDLE;
        clk <= 0;
    end

endmodule