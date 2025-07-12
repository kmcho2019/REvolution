module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [31:0] cnt1; // Counter for rising edges
reg [31:0] cnt2; // Counter for falling edges
reg        clk_div1; // Divided clock for positive edges
reg        clk_div2; // Divided clock for negative edges

// Initialize counters and clock dividers on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt1 < (NUM_DIV / 2) - 1) begin
            cnt1 <= cnt1 + 1;
        end else if (cnt1 == (NUM_DIV / 2) - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end

        if (cnt2 < (NUM_DIV / 2) - 1) begin
            cnt2 <= cnt2 + 1;
        end else if (cnt2 == (NUM_DIV / 2) - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end
    end
end

// Toggle counters on positive and negative edges
always @(posedge clk) begin
    cnt1 <= cnt1 + 1;
end

always @(negedge clk) begin
    cnt2 <= cnt2 + 1;
end

// Derive final divided clock output
always @(posedge clk or negedge clk) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= (clk_div1 | clk_div2);
    end
end

endmodule