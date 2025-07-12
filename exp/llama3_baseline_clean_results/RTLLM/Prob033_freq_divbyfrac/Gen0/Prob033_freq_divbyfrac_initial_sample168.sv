module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the multiplication factor for the fractional division
localparam MUL2_DIV_CLK = 7;

// Counter to cycle through the clock periods
reg [2:0] counter;

// Signals for the intermediate divided clocks
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_phase;
reg clk_div_3_phase;

// Initialize the counter and signals
initial begin
    counter = 0;
    clk_div_4 = 0;
    clk_div_3 = 0;
    clk_div_4_phase = 0;
    clk_div_3_phase = 0;
    clk_div = 0;
end

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        clk_div_4 <= 0;
        clk_div_3 <= 0;
        clk_div_4_phase <= 0;
        clk_div_3_phase <= 0;
        clk_div <= 0;
    end
end

// Counter logic
always @(posedge clk) begin
    if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Generate the intermediate divided clocks
always @(posedge clk) begin
    if (counter == 3) begin
        clk_div_4 <= 1;
    end else if (counter == 7) begin
        clk_div_4 <= 0;
    end
    
    if (counter == 0) begin
        clk_div_3 <= 1;
    end else if (counter == 3) begin
        clk_div_3 <= 0;
    end
end

// Generate the phase-shifted versions of the divided clocks
always @(posedge clk) begin
    if (counter == 0) begin
        clk_div_4_phase <= ~clk_div_4;
    end else begin
        clk_div_4_phase <= clk_div_4;
    end
    
    if (counter == 3) begin
        clk_div_3_phase <= ~clk_div_3;
    end else begin
        clk_div_3_phase <= clk_div_3;
    end
end

// Generate the final fractional divided clock output
always @(posedge clk) begin
    clk_div <= clk_div_4 | clk_div_3 | clk_div_4_phase | clk_div_3_phase;
end

endmodule