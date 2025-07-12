module freq_divbyfrac (
    input  clk,
    input  rst_n,
    output reg clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Modulus for the counter
parameter DIV_CYCLES_1 = 4; // Number of clock cycles for the first intermediate clock
parameter DIV_CYCLES_2 = 3; // Number of clock cycles for the second intermediate clock

// Internal signals
reg [2:0] counter; // Counter to track the input clock cycles
reg clk_int1; // First intermediate clock
reg clk_int2; // Second intermediate clock
reg clk_int1_dly; // Delayed version of the first intermediate clock
reg clk_int2_adv; // Advanced version of the second intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
    end
end

// Generate intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1 <= 0;
        clk_int2 <= 0;
    end else begin
        if (counter == DIV_CYCLES_1 - 1) begin
            clk_int1 <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int1 <= 0;
        end
        
        if (counter == DIV_CYCLES_2 - 1) begin
            clk_int2 <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int2 <= 0;
        end
    end
end

// Phase-shift the intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int1_dly <= 0;
        clk_int2_adv <= 0;
    end else begin
        clk_int1_dly <= clk_int1;
        if (counter == MUL2_DIV_CLK / 2 - 1) begin
            clk_int2_adv <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int2_adv <= 0;
        end
    end
end

// Generate the final divided clock
assign clk_div = clk_int1 || clk_int2_adv;

endmodule