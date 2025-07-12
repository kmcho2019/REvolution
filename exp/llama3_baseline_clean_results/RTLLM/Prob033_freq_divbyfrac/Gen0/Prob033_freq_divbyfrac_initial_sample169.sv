module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Multiplier for fractional division
parameter DIV_CLK0 = 4;      // Uneven clock period 1
parameter DIV_CLK1 = 3;      // Uneven clock period 2

// Internal signals
reg [2:0] cnt;              // Counter for clock cycles
reg clk_div_int0;           // Intermediate divided clock signal 1
reg clk_div_int1;           // Intermediate divided clock signal 2
reg clk_div_delayed;        // Delayed version of intermediate clock signal
reg clk_div_advanced;       // Advanced version of intermediate clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int0 <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            if (DIV_CLK0 == 4) begin
                clk_div_int0 <= 1'b1;
            end else begin
                clk_div_int0 <= 1'b0;
            end
            if (DIV_CLK1 == 3) begin
                clk_div_int1 <= 1'b1;
            end else begin
                clk_div_int1 <= 1'b0;
            end
        end else begin
            cnt <= cnt + 1;
            if (cnt == DIV_CLK0 - 1) begin
                clk_div_int0 <= 1'b0;
            end
            if (cnt == DIV_CLK1 - 1) begin
                clk_div_int1 <= 1'b0;
            end
        end
    end
end

// Double-edge clocking logic
always @(posedge clk) begin
    if (~rst_n) begin
        clk_div_delayed <= 1'b0;
        clk_div_advanced <= 1'b0;
    end else begin
        clk_div_delayed <= clk_div_int1;
        clk_div_advanced <= clk_div_int0;
    end
end

// Final clock output logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_int0 | clk_div_delayed | clk_div_advanced;
    end
end

endmodule