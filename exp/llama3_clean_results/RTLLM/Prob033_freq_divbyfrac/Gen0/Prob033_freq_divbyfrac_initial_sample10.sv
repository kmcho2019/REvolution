module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the multiplication factor for 3.5x division
localparam MUL2_DIV_CLK = 7;

// Counter to track the clock cycles
reg [2:0] cycle_counter;

// Intermediate clock signals
reg clk_int1, clk_int2;
reg clk_int1_dly, clk_int2_adv;

// Initialize the counter and intermediate clocks
initial begin
    cycle_counter <= 3'd0;
    clk_int1 <= 1'b0;
    clk_int2 <= 1'b0;
    clk_int1_dly <= 1'b0;
    clk_int2_adv <= 1'b0;
    clk_div <= 1'b0;
end

// Synchronous reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cycle_counter <= 3'd0;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
        clk_int1_dly <= 1'b0;
        clk_int2_adv <= 1'b0;
        clk_div <= 1'b0;
    end
    else begin
        // Increment the cycle counter
        if (cycle_counter == MUL2_DIV_CLK - 1) begin
            cycle_counter <= 3'd0;
        end
        else begin
            cycle_counter <= cycle_counter + 1;
        end

        // Generate intermediate clock signals
        if (cycle_counter == 3'd3 || cycle_counter == 3'd6) begin
            clk_int1 <= ~clk_int1;
        end

        if (cycle_counter == 3'd0 || cycle_counter == 3'd4) begin
            clk_int2 <= ~clk_int2;
        end

        // Phase-shift the intermediate clock signals
        if (clk_int1) begin
            clk_int1_dly <= ~clk_int1_dly;
        end
        else begin
            clk_int1_dly <= clk_int1_dly;
        end

        if (clk_int2) begin
            clk_int2_adv <= ~clk_int2_adv;
        end
        else begin
            clk_int2_adv <= clk_int2_adv;
        end

        // Logically OR the phase-shifted clock signals
        clk_div <= clk_int1 || clk_int2 || clk_int1_dly || clk_int2_adv;
    end
end

endmodule