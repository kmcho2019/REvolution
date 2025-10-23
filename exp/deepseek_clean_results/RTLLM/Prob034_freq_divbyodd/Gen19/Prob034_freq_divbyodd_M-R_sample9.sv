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

localparam HALF_CYCLE = (NUM_DIV - 1) >> 1;
reg [31:0] cnt_pos, cnt_neg;
wire toggle_pos, toggle_neg;
reg clk_pos, clk_neg;

// Positive edge counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_pos <= 0;
    end else begin
        cnt_pos <= (cnt_pos == NUM_DIV - 1) ? 0 : cnt_pos + 1;
    end
end

// Negative edge counter
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_neg <= 0;
    end else begin
        cnt_neg <= (cnt_neg == NUM_DIV - 1) ? 0 : cnt_neg + 1;
    end
end

// Toggle signals
assign toggle_pos = (cnt_pos == HALF_CYCLE) || (cnt_pos == NUM_DIV - 1);
assign toggle_neg = (cnt_neg == HALF_CYCLE) || (cnt_neg == NUM_DIV - 1);

// Positive edge clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 0;
    end else if (toggle_pos) begin
        clk_pos <= ~clk_pos;
    end
end

// Negative edge clock generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 0;
    end else if (toggle_neg) begin
        clk_neg <= ~clk_neg;
    end
end

// Output clock generation (XOR for proper duty cycle)
assign clk_div = clk_pos ^ clk_neg;

endmodule