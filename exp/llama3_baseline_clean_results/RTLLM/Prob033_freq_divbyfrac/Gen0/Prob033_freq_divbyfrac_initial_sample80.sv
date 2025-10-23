module freq_divbyfrac (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants for the division ratio
localparam MUL2_DIV_CLK = 7; // For 3.5x division
localparam COUNTER_MAX = MUL2_DIV_CLK - 1;

// Counter to keep track of clock cycles
reg [2:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter
    end else begin
        if (counter == COUNTER_MAX) begin
            counter <= 3'b000; // Reset counter when max value is reached
        end else begin
            counter <= counter + 1'b1; // Increment counter
        end
    end
end

// Signals for intermediate clocks
reg clk_div_int_4; // Clock with 4 cycles period
reg clk_div_int_3; // Clock with 3 cycles period
reg clk_div_int_4_shifted; // Phase-shifted version of clk_div_int_4
reg clk_div_int_3_shifted; // Phase-shifted version of clk_div_int_3

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_4 <= 1'b0;
        clk_div_int_3 <= 1'b0;
    end else begin
        if (counter == 3'b100) begin // Counter value when intermediate clocks switch
            clk_div_int_4 <= ~clk_div_int_4; // Toggle clk_div_int_4
            clk_div_int_3 <= ~clk_div_int_3; // Toggle clk_div_int_3
        end
    end
end

// Phase-shift intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_4_shifted <= 1'b0;
        clk_div_int_3_shifted <= 1'b0;
    end else begin
        if (counter == 3'b001) begin // Counter value for phase shift
            clk_div_int_4_shifted <= ~clk_div_int_4; // Phase shift clk_div_int_4 by half cycle
            clk_div_int_3_shifted <= ~clk_div_int_3; // Phase shift clk_div_int_3 by half cycle
        end else begin
            clk_div_int_4_shifted <= clk_div_int_4; // No phase shift
            clk_div_int_3_shifted <= clk_div_int_3; // No phase shift
        end
    end
end

// Duty cycle control: ensure 4 cycles for one clock and 3 cycles for the other
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_4 <= 1'b0;
    end else if (counter == 3'b000 || counter == 3'b001 || counter == 3'b010 || counter == 3'b011) begin
        clk_div_int_4 <= 1'b1;
    end else begin
        clk_div_int_4 <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_3 <= 1'b0;
    end else if (counter == 3'b100 || counter == 3'b101 || counter == 3'b110) begin
        clk_div_int_3 <= 1'b1;
    end else begin
        clk_div_int_3 <= 1'b0;
    end
end

// Final output generation: OR the phase-shifted intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_int_4_shifted | clk_div_int_3_shifted;
    end
end

endmodule