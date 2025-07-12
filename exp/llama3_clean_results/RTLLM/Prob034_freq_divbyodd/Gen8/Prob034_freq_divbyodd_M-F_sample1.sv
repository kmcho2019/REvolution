module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Single counter for both rising and falling edges
reg        clk_div1;  // Clock divider for positive edges
reg        clk_div2;  // Clock divider for negative edges
reg        rising_edge;  // Flag for the current edge

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        rising_edge <= 1'b1;
    end else begin
        rising_edge <= (clk == 1'b1);
        cnt <= (cnt == (NUM_DIV - 1))? 0 : cnt + 1;
        
        // Calculate the midpoint of the divisor, rounded to the nearest integer
        if (cnt == ((NUM_DIV + 1) / 2 - 1)) begin
            clk_div1 <= ~clk_div1;
        end
        if (cnt == ((NUM_DIV / 2) - 1)) begin
            clk_div2 <= ~clk_div2;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule