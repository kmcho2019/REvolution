module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameter validation
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Positive edge counter and clock
reg [31:0] pos_cnt;
reg pos_clk;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        pos_clk <= 0;
    end else begin
        if (pos_cnt == NUM_DIV - 1) begin
            pos_cnt <= 0;
            pos_clk <= ~pos_clk;
        end else if (pos_cnt == HALF_DIV) begin
            pos_cnt <= pos_cnt + 1;
            pos_clk <= ~pos_clk;
        end else begin
            pos_cnt <= pos_cnt + 1;
        end
    end
end

// Negative edge counter and clock
reg [31:0] neg_cnt;
reg neg_clk;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
        neg_clk <= 0;
    end else begin
        if (neg_cnt == NUM_DIV - 1) begin
            neg_cnt <= 0;
            neg_clk <= ~neg_clk;
        end else if (neg_cnt == HALF_DIV) begin
            neg_cnt <= neg_cnt + 1;
            neg_clk <= ~neg_clk;
        end else begin
            neg_cnt <= neg_cnt + 1;
        end
    end
end

// Combine both clocks
assign clk_div = pos_clk | neg_clk;

endmodule