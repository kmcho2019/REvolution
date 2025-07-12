module freq_divbyfrac (
    input         clk,        // Input clock signal
    input         rst_n,      // Active low reset signal
    output        clk_div     // Fractionally divided clock output
);

// Parameters
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;               // Counter to cycle through MUL2_DIV_CLK
reg clk_div_int1;            // Intermediate divided clock signal 1
reg clk_div_int2;            // Intermediate divided clock signal 2
reg clk_div_int1_dly;        // Delayed version of clk_div_int1
reg clk_div_int2_adv;        // Advanced version of clk_div_int2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
        if (clk_div_int1) begin
            clk_div_int1 <= 1'b0;
        end else if (cnt == 3'b100) begin
            clk_div_int1 <= 1'b1;
        end
        if (clk_div_int2) begin
            clk_div_int2 <= 1'b0;
        end else if (cnt == 3'b011) begin
            clk_div_int2 <= 1'b1;
        end
    end else begin
        cnt <= cnt + 1'b1;
        if (cnt == 3'b100) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == 3'b111) begin
            clk_div_int1 <= 1'b0;
        end
        if (cnt == 3'b011) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == 3'b101) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Double-edge clocking and phase-shifting
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        clk_div_int1_dly <= clk_div_int1;
        clk_div_int2_adv <= clk_div_int2;
    end
end

// Final clock generation
assign clk_div = clk_div_int1_dly | clk_div_int2_adv;

endmodule