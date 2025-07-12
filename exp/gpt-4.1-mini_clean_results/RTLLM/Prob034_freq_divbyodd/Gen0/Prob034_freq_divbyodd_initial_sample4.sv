module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Calculate half of the divisor - integer division floor
localparam HALF_DIV = (NUM_DIV - 1) >> 1;

reg [$clog2(NUM_DIV):0] cnt1;
reg [$clog2(NUM_DIV):0] cnt2;
reg clk_div1;
reg clk_div2;

// Rising edge: count cnt1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 0;
    end else begin
        if (cnt1 == HALF_DIV) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end
end

// Falling edge: count cnt2
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt2 == HALF_DIV) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Final divided clock is OR of both halves
assign clk_div = clk_div1 | clk_div2;

endmodule