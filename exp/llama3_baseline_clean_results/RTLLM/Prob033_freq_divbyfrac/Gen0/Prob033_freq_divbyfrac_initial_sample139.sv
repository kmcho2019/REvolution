module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
localparam MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles
localparam DIV_CLK_CYCLES_1 = 4; // First uneven clock period (4 source clock cycles)
localparam DIV_CLK_CYCLES_2 = 3; // Second uneven clock period (3 source clock cycles)

// Internal signals
reg [2:0] counter; // Counter to keep track of clock cycles
reg clk_div_int1; // Intermediate divided clock signal 1
reg clk_div_int2; // Intermediate divided clock signal 2
reg clk_div_int1_dly; // Phase-shifted intermediate divided clock signal 1
reg clk_div_int2_adv; // Phase-shifted intermediate divided clock signal 2

// Counter logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b0;
            clk_div_int1_dly <= 1'b0;
            clk_div_int2_adv <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
            if (counter < DIV_CLK_CYCLES_1) begin
                clk_div_int1 <= 1'b1;
            end else begin
                clk_div_int1 <= 1'b0;
            end
            if (counter >= DIV_CLK_CYCLES_1 && counter < MUL2_DIV_CLK) begin
                clk_div_int2 <= 1'b1;
            end else begin
                clk_div_int2 <= 1'b0;
            end
        end
    end
end

// Phase-shifting logic
always @ (posedge clk) begin
    if (clk_div_int1) begin
        clk_div_int1_dly <= ~clk_div_int1;
    end else begin
        clk_div_int1_dly <= clk_div_int1;
    end
    if (clk_div_int2) begin
        clk_div_int2_adv <= ~clk_div_int2;
    end else begin
        clk_div_int2_adv <= clk_div_int2;
    end
end

// Final divided clock output
always @ (posedge clk) begin
    if (rst_n) begin
        clk_div <= clk_div_int1_dly | clk_div_int2_adv;
    end else begin
        clk_div <= 1'b0;
    end
end

endmodule