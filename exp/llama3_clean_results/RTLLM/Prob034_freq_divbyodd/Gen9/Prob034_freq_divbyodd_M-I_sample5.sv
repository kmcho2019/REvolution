module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter for total edges
reg        clk_div1;  // Clock divider for positive edges
reg        clk_div2;  // Clock divider for negative edges
reg        edge;  // Flag for current edge (0: falling, 1: rising)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div1 <= 1'b0;
        edge <= 1'b1;
    end else begin
        if (edge) begin
            cnt <= cnt + 1;
            if (cnt == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt <= 0;
            end
        end
        edge <= 1'b0;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div2 <= 1'b0;
    end else begin
        if (~edge) begin
            cnt <= cnt + 1;
            if (cnt == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt <= 0;
            end
        end
        edge <= 1'b1;
    end
end

// Generate divided clock output
assign clk_div = clk_div1 || clk_div2;

endmodule