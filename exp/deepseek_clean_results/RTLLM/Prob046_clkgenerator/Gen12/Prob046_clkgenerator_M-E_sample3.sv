`timescale 1ns/1ps

module clkgenerator #(
    parameter INIT_PERIOD = 10  // Initial clock period in ns
) (
    output reg clk,             // Generated clock output
    input wire clk_ref,         // Reference clock (faster than generated clock)
    input wire reset_n,         // Active-low synchronous reset
    input wire enable,          // Clock enable
    input wire period_update,   // Pulse to update period
    input wire [15:0] new_period // New period value
);

    reg [15:0] current_period;
    reg [15:0] counter;
    reg [15:0] half_period;
    reg pending_update;
    
    // FSM states
    typedef enum {NORMAL, UPDATE_WAIT_HIGH, UPDATE_WAIT_LOW} state_t;
    state_t state;

    // Initialize parameters
    initial begin
        current_period = INIT_PERIOD;
        half_period = INIT_PERIOD / 2;
        state = NORMAL;
    end

    always @(posedge clk_ref or negedge reset_n) begin
        if (!reset_n) begin
            clk <= 0;
            counter <= 0;
            current_period <= INIT_PERIOD;
            half_period <= INIT_PERIOD / 2;
            pending_update <= 0;
            state <= NORMAL;
        end
        else if (enable) begin
            case (state)
                NORMAL: begin
                    if (counter >= half_period-1) begin
                        clk <= ~clk;
                        counter <= 0;
                        if (clk) begin
                            half_period <= current_period / 2;
                            if (pending_update) begin
                                current_period <= new_period;
                                pending_update <= 0;
                            end
                        end
                    end
                    else begin
                        counter <= counter + 1;
                    end
                    
                    if (period_update) begin
                        pending_update <= 1;
                    end
                end
                
                UPDATE_WAIT_HIGH: begin
                    if (clk) begin
                        state <= UPDATE_WAIT_LOW;
                    end
                end
                
                UPDATE_WAIT_LOW: begin
                    if (!clk) begin
                        current_period <= new_period;
                        state <= NORMAL;
                    end
                end
            endcase
        end
    end

endmodule