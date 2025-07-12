module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV Kohana = 4; // Clock cycles for first phase
parameter DIV_Kobo = 3; // Clock cycles for second phase

// Internal signals
reg [2:0] counter; // Counter for tracking clock cycles
reg clk_int1, clk_int2; // Intermediate clocks
reg clk_int1_shifted, clk_int2_shifted; // Phase-shifted intermediate clocks
reg prev_clk; // Previous clock value for edge detection

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        prev_clk <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end
        prev_clk <= clk;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else begin
        if (counter == DIV_Kohanab - 1) begin
            clk_int1 <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 1'b0;
        end
        
        if (counter == DIV_Kobo - 1) begin
            clk_int2 <= 1'b1;
        end else if (counter == DIV_Kohanab) begin
            clk_int2 <= 1'b0;
        end
    end
end

// Phase-shift intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1_shifted <= 1'b0;
        clk_int2_shifted <= 1'b0;
    end else begin
        // Detect rising and falling edges
        if (clk && !prev_clk) begin // Rising edge
            clk_int1_shifted <= clk_int1;
            clk_int2_shifted <= 1'b0; // Reset on rising edge
        end else if (!clk && prev_clk) begin // Falling edge
            clk_int2_shifted <= clk_int2;
            clk_int1_shifted <= 1'b0; // Reset on falling edge
        end
    end
end

// Generate final divided clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_int1_shifted | clk_int2_shifted;
    end
end

endmodule