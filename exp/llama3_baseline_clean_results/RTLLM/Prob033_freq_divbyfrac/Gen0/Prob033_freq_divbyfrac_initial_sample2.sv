module freq_divbyfrac (
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

// Parameters for 3.5x division (7 clock cycles total, divided into 4 and 3)
parameter MUL2_DIV_CLK = 7;

// Internal signals
reg [2:0]  counter;  // Counter to track the 7 clock cycles
reg        clk_int1; // First intermediate divided clock signal
reg        clk_int2; // Second intermediate divided clock signal
reg        clk_delay; // Delayed version of clk_int1
reg        clk_adv;   // Advanced version of clk_int2

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        clk_int1 <= 0;
        clk_int2 <= 0;
        clk_delay <= 0;
        clk_adv <= 0;
    end else begin
        // Counter logic to cycle through 7 clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate clock signals
        // First 4 cycles: clk_int1 high, last 3 cycles: clk_int2 high
        if (counter < 4) begin
            clk_int1 <= 1;
            clk_int2 <= 0;
        end else begin
            clk_int1 <= 0;
            clk_int2 <= 1;
        end

        // Phase-shifting logic
        // Delay clk_int1 by half a clock period
        if (counter == 3) begin
            clk_delay <= 1;
        end else if (counter == 0) begin
            clk_delay <= 0;
        end else begin
            clk_delay <= clk_delay;
        end

        // Advance clk_int2 by half a clock period
        if (counter == 6) begin
            clk_adv <= 1;
        end else if (counter == 3) begin
            clk_adv <= 0;
        end else begin
            clk_adv <= clk_adv;
        end
    end
end

// Final output logic
assign clk_div = (clk_int1 | clk_delay) | (clk_int2 | clk_adv);

endmodule