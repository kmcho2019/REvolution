module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg        clk_div_int;  // Internal divided clock output
reg        toggle;  // Toggle signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int <= 1'b0;
        toggle <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
            toggle <= ~toggle;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = (cnt == (NUM_DIV / 2)) ? toggle : 1'b0;

endmodule