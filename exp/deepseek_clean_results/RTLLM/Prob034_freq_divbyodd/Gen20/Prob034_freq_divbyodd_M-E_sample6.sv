module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HALF_DIV = (NUM_DIV - 1) / 2;
reg [31:0] cnt_p, cnt_n;
reg clk_p, clk_n;

// Positive edge counter and clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_p <= 0;
        clk_p <= 0;
    end else begin
        cnt_p <= (cnt_p == NUM_DIV - 1) ? 0 : cnt_p + 1;
        if (cnt_p == HALF_DIV || cnt_p == NUM_DIV - 1) begin
            clk_p <= ~clk_p;
        end
    end
end

// Negative edge counter and clock generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt_n <= 0;
        clk_n <= 0;
    end else begin
        cnt_n <= (cnt_n == NUM_DIV - 1) ? 0 : cnt_n + 1;
        if (cnt_n == HALF_DIV || cnt_n == NUM_DIV - 1) begin
            clk_n <= ~clk_n;
        end
    end
end

// Combine both phases
assign clk_div = clk_p | clk_n;

endmodule