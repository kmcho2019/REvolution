`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10,         // Total clock period in ns
    parameter DUTY_CYCLE = 50      // Duty cycle percentage
) (
    input wire clk_en,             // Clock enable
    input wire reset,              // Active-high synchronous reset
    output reg clk_out             // Generated clock signal
);

    // Calculate timing parameters
    localparam HIGH_CYCLES = (PERIOD * DUTY_CYCLE + 50) / 100; // Round to nearest integer
    localparam LOW_CYCLES = PERIOD - HIGH_CYCLES;
    
    // State definition
    typedef enum {HIGH_PHASE, LOW_PHASE} clk_state_t;
    clk_state_t state, next_state;
    
    // Timing counter
    reg [31:0] counter;
    
    // State transition and output logic
    always @(*) begin
        case (state)
            HIGH_PHASE: begin
                clk_out = 1'b1;
                next_state = (counter >= HIGH_CYCLES-1) ? LOW_PHASE : HIGH_PHASE;
            end
            LOW_PHASE: begin
                clk_out = 1'b0;
                next_state = (counter >= LOW_CYCLES-1) ? HIGH_PHASE : LOW_PHASE;
            end
            default: begin
                clk_out = 1'b0;
                next_state = LOW_PHASE;
            end
        endcase
    end
    
    // State and counter update
    always @(posedge clk_en or posedge reset) begin
        if (reset) begin
            state <= LOW_PHASE;
            counter <= 0;
        end else begin
            if (state != next_state) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
            state <= next_state;
        end
    end

endmodule