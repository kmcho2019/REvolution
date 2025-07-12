module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_CYCLE = (NUM_DIV - 1) >> 1;
reg [31:0] cnt;
wire toggle_pos, toggle_neg;
reg clk_pos, clk_neg;

// Combined edge counter
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
    end
end

// Toggle signals
assign toggle_pos = (cnt >= HALF_CYCLE) & (cnt != NUM_DIV - 1);
assign toggle_neg = (cnt >= HALF_CYCLE) & (cnt != NUM_DIV - 1);

// Positive edge clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 0;
    end else begin
        clk_pos <= toggle_pos;
    end
end

// Negative edge clock generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 0;
    end else begin
        clk_neg <= toggle_neg;
    end
end

// Output clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_pos | clk_neg;
    end
end

endmodule