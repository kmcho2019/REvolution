module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_div1, clk_div2;
wire clk_inv;
reg rst_sync1, rst_sync2;

// Synchronized reset for main clock domain
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rst_sync1 <= 1'b0;
        rst_sync2 <= 1'b0;
    end else begin
        rst_sync1 <= 1'b1;
        rst_sync2 <= rst_sync1;
    end
end

// Inverted clock for phase shifting
assign clk_inv = ~clk;

// Single-edge 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else if (rst_sync2) begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Base divided clock (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div1 <= 1'b0;
    end else if (rst_sync2) begin
        clk_div1 <= (counter <= 3'd3) ? 1'b1 : 1'b0;
    end
end

// Phase-shifted clock (3 cycles high, 4 cycles low)
always @(posedge clk_inv or negedge rst_n) begin
    if (!rst_n) begin
        clk_div2 <= 1'b0;
    end else if (rst_sync2) begin
        clk_div2 <= (counter <= 3'd2) ? 1'b1 : 1'b0;
    end
end

// Final output combines both phases
assign clk_div = clk_div1 | clk_div2;

endmodule