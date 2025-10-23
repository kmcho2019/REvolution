module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Verify odd division factor
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Rising edge domain
reg [31:0] pos_cnt;
reg pos_clk;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pos_cnt <= 0;
        pos_clk <= 0;
    end
    else begin
        if (pos_cnt == HALF_DIV) begin
            pos_clk <= ~pos_clk;
            pos_cnt <= 0;
        end
        else begin
            pos_cnt <= pos_cnt + 1;
        end
    end
end

// Falling edge domain
reg [31:0] neg_cnt;
reg neg_clk;

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        neg_cnt <= 0;
        neg_clk <= 0;
    end
    else begin
        if (neg_cnt == HALF_DIV) begin
            neg_clk <= ~neg_clk;
            neg_cnt <= 0;
        end
        else begin
            neg_cnt <= neg_cnt + 1;
        end
    end
end

// Combine both edge domains
assign clk_div = pos_clk ^ neg_clk;

endmodule