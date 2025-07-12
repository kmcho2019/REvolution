module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [2:0] cnt;  // Counter to track the edges
reg        clk_div1;  // Clock divider for positive edge
reg        clk_div2;  // Clock divider for negative edge
reg        rising_edge;  // Flag for rising edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        rising_edge <= 1'b1;
    end else begin
        if (rising_edge) begin
            if (cnt == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt <= cnt + 1;
                rising_edge <= 1'b0;
            end else begin
                cnt <= cnt + 1;
            end
        end else begin
            if (cnt == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt <= cnt + 1;
                rising_edge <= 1'b1;
            end else begin
                cnt <= cnt + 1;
            end
        end
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 3'b000;
        end
    end
end

// Derive the final divided clock output
assign clk_div = clk_div1 | clk_div2;

endmodule