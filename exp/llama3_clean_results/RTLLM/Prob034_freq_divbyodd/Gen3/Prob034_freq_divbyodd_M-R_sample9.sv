module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt; // Counter
reg        clk_div1; // Clock divider
reg        rising_edge; // Flag for rising edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div1 <= 1'b0;
        rising_edge <= 1'b1;
    end else begin
        if (rising_edge) begin
            cnt <= cnt + 1;
            if (cnt == NUM_DIV) begin
                cnt <= 0;
                rising_edge <= ~rising_edge;
                clk_div1 <= ~clk_div1;
            end
        end else begin
            cnt <= cnt + 1;
            if (cnt == NUM_DIV) begin
                cnt <= 0;
                rising_edge <= ~rising_edge;
            end
        end
    end
end

assign clk_div = clk_div1;

endmodule