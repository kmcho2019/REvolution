module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

localparam COUNTER_WIDTH = $clog2(NUM_DIV * 2);

reg [COUNTER_WIDTH-1:0] cnt;  // Counter for clock edges
reg        clk_div_int;  // Internal divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV * 2 - 1)) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = clk_div_int;

endmodule