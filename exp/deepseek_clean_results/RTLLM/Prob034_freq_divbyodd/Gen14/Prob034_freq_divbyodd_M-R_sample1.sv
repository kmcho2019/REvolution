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

localparam HALF_CYCLE = (NUM_DIV - 1) / 2;
reg [31:0] cnt;
reg pos_clk, neg_clk;
wire cnt_max = (cnt == NUM_DIV - 1);
wire cnt_half = (cnt == HALF_CYCLE);

// State tracking and clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        pos_clk <= 0;
    end else begin
        if (cnt_max) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        
        if (cnt_half || cnt_max) begin
            pos_clk <= ~pos_clk;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_clk <= 0;
    end else begin
        if (cnt_half || cnt_max) begin
            neg_clk <= ~neg_clk;
        end
    end
end

// Combine both clocks
assign clk_div = pos_clk | neg_clk;

endmodule