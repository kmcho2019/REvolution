module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7; // total clock cycles for fractional division
localparam DIV_CLK_MEDIUM = 4; // clock cycles for one phase
localparam DIV_CLK_SHORT = 3; // clock cycles for another phase

reg [2:0] counter; // counter for 7 clock cycles
reg clk_div_int1; // intermediate clock signal 1
reg clk_div_int2; // intermediate clock signal 2
reg clk_div_int1_delayed; // delayed version of intermediate clock signal 1
reg clk_div_int2_advanced; // advanced version of intermediate clock signal 2

// Counter for 7 clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate clock signals
        if (counter == DIV_CLK_MEDIUM) begin
            clk_div_int1 <= 1'b1;
        end else if (counter == DIV_CLK_MEDIUM + 1) begin
            clk_div_int1 <= 1'b0;
        end

        if (counter == DIV_CLK_SHORT) begin
            clk_div_int2 <= 1'b1;
        end else if (counter == DIV_CLK_SHORT + 1) begin
            clk_div_int2 <= 1'b0;
        end

        // Generate phase-shifted clock signals
        if (counter == DIV_CLK_MEDIUM - 1) begin
            clk_div_int1_delayed <= 1'b1;
        end else if (counter == DIV_CLK_MEDIUM) begin
            clk_div_int1_delayed <= 1'b0;
        end

        if (counter == DIV_CLK_SHORT + 1) begin
            clk_div_int2_advanced <= 1'b1;
        end else if (counter == DIV_CLK_SHORT + 2) begin
            clk_div_int2_advanced <= 1'b0;
        end
    end
end

// Logically OR the phase-shifted clock signals to produce the final output
assign clk_div = clk_div_int1_delayed | clk_div_int2_advanced;

endmodule