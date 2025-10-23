module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt1; // Counter for positive edge
reg [31:0] cnt2; // Counter for negative edge
reg        clk_div1; // Divided clock output for positive edge
reg        clk_div2; // Divided clock output for negative edge

// Reset counters and divided clock outputs
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 < NUM_DIV - 1) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
            end
        end

        if (cnt2 < NUM_DIV - 1) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

// Derive final divided clock output
always @(posedge clk) begin
    clk_div <= clk_div1 | clk_div2;
end

endmodule