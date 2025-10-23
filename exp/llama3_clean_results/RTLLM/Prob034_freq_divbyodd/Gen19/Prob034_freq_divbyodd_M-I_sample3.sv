module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

// Calculate the minimum width required for the counter
localparam INT_WIDTH = $clog2(NUM_DIV);

reg [INT_WIDTH-1:0] cnt;  // Counter to track the edges
reg        clk_div_int;  // Internal clock divider

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Derive the final divided clock output directly from the counter
assign clk_div = clk_div_int;

endmodule