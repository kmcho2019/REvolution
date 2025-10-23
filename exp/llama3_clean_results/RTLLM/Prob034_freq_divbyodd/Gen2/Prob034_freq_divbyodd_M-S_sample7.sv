module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output reg         clk_div
);

reg [31:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1) / 2) begin
            cnt <= cnt + 1;
            clk_div <= ~clk_div;
        end else if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule