module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam CNT_MAX = NUM_DIV - 1;
localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;

reg [31:0] pos_cnt, neg_cnt;
reg pos_clk, neg_clk;
reg rst_n_sync;

// Synchronize reset to negative edge domain
always @(negedge clk) begin
    rst_n_sync <= rst_n;
end

// Positive edge counter and clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        pos_clk <= 0;
    end else begin
        if (pos_cnt == CNT_MAX) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= pos_cnt + 1;
        end
        
        if (pos_cnt == TOGGLE_POINT) begin
            pos_clk <= ~pos_clk;
        end
    end
end

// Negative edge counter and clock
always @(negedge clk or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
        neg_cnt <= 0;
        neg_clk <= 0;
    end else begin
        if (neg_cnt == CNT_MAX) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= neg_cnt + 1;
        end
        
        if (neg_cnt == TOGGLE_POINT) begin
            neg_clk <= ~neg_clk;
        end
    end
end

// Combine both clocks with OR
assign clk_div = pos_clk | neg_clk;

endmodule