module freq_divbyfrac(
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

// Define parameters for fractional division
parameter MUL2_DIV_CLK = 7;  // Multiplication factor for fractional division (7 for 3.5x division)

// Internal signals for clock division and phase shifting
reg [2:0]  counter;          // Counter to track the clock cycles
reg        clk_div_int;      // Intermediate divided clock signal
reg        clk_div_phase1;   // Phase-shifted clock signal 1 (delayed by half a cycle)
reg        clk_div_phase2;   // Phase-shifted clock signal 2 (advanced by half a cycle)
reg        clk_div_phase1_d; // Registered delayed version of clk_div_phase1
reg        clk_div_phase2_d; // Registered advanced version of clk_div_phase2

// Counter logic to generate the intermediate divided clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;  // Reset counter to 0
        clk_div_int <= 1'b0; // Reset intermediate clock to 0
    end else if (counter == MUL2_DIV_CLK - 1) begin
        // When counter reaches the end of the cycle, reset it and toggle the intermediate clock
        counter <= 3'b000;
        clk_div_int <= ~clk_div_int;
    end else if (counter == 3'b100) begin
        // Special handling for the 4th cycle to create uneven clock periods
        counter <= counter + 1'b1;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate phase-shifted clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_phase1 <= 1'b0; // Reset phase-shifted clock 1 to 0
        clk_div_phase2 <= 1'b0; // Reset phase-shifted clock 2 to 0
    end else begin
        // Delayed version of clk_div_phase1
        clk_div_phase1_d <= clk_div_int;
        // Advanced version of clk_div_phase2 (considering the current and next state)
        if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_phase2 <= 1'b1;
        end else if (counter == 3'b000) begin
            clk_div_phase2 <= 1'b0;
        end
        // Assign the phase-shifted clocks
        clk_div_phase1 <= clk_div_phase1_d;
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_phase1 | clk_div_phase2;

endmodule