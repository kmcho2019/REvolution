module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

localparam integer MUL2_DIV_CLK = 7;

reg [2:0] cnt;                 // 3-bit counter for counting up to 7
reg       clk_int_rise;        // intermediate clock toggled on rising edge
reg       clk_int_fall;        // intermediate clock toggled on falling edge

// Counter increments on rising edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'd0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end
end

// Toggle clk_int_rise on rising edge according to uneven cycle lengths
// We create a toggle pattern that produces periods of 4 and 3 clocks:
// Toggle clk_int_rise at cnt == 0 and cnt == 4 (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int_rise <= 1'b0;
    end else begin
        if (cnt == 3'd0 || cnt == 3'd4)
            clk_int_rise <= ~clk_int_rise;
    end
end

// Toggle clk_int_fall on falling edge at cnt==1 and cnt==5 (phase shifted by half clk period)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_int_fall <= 1'b0;
    end else begin
        if (cnt == 3'd1 || cnt == 3'd5)
            clk_int_fall <= ~clk_int_fall;
    end
end

// OR the two intermediate clocks to generate the final fractional divided clock
assign clk_div = clk_int_rise | clk_int_fall;

endmodule