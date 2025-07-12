module clkgenerator #(
    parameter PERIOD = 10
) (
    output reg clk,               // Generated clock output
    output wire clk_ready,        // Clock stable indicator
    input wire [15:0] period_in,  // Dynamic period input
    input wire update_period,     // Pulse to update period
    input wire reset_n            // Active-low reset
);

    reg [15:0] current_period;
    reg [15:0] counter;
    reg [15:0] new_period_reg;
    reg update_pending;
    reg period_loaded;

    // Calculate duty cycle parameters
    wire [15:0] high_time = (current_period + 1) >> 1;
    wire [15:0] low_time = current_period >> 1;

    // Clock ready indicator
    assign clk_ready = period_loaded && !update_pending;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_period <= PERIOD;
            new_period_reg <= PERIOD;
            update_pending <= 1'b0;
            period_loaded <= 1'b1;
        end else if (update_period) begin
            new_period_reg <= period_in;
            update_pending <= 1'b1;
            period_loaded <= 1'b0;
        end
    end

    // Main clock generation process
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 16'd0;
            clk <= 1'b0;
        end else begin
            if (update_pending && (counter == 0)) begin
                current_period <= new_period_reg;
                update_pending <= 1'b0;
                period_loaded <= 1'b1;
            end

            if (counter == current_period - 1) begin
                counter <= 16'd0;
                clk <= 1'b1;
            end else if (counter == high_time - 1) begin
                clk <= 1'b0;
                counter <= counter + 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Initial clock kick-start
    initial begin
        clk = 1'b0;
        #1 clk = 1'b1; // Ensure first edge occurs
    end

endmodule