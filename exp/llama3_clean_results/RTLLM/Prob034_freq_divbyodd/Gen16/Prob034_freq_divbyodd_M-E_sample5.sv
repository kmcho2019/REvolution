module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt_rising;
logic [$clog2(NUM_DIV-1):0] cnt_falling;
logic clk_div_rising;
logic clk_div_falling;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div_rising <= 1'b0;
        clk_div_falling <= 1'b0;
    end else begin
        if (clk == 1'b1) begin
            cnt_rising <= cnt_rising + 1;
            if (cnt_rising == (NUM_DIV / 2) - 1) begin
                cnt_rising <= 0;
                clk_div_rising <= ~clk_div_rising;
            end
        end else begin
            cnt_falling <= cnt_falling + 1;
            if (cnt_falling == (NUM_DIV / 2) - 1) begin
                cnt_falling <= 0;
                clk_div_falling <= ~clk_div_falling;
            end
        end
    end
end

assign clk_div = clk_div_rising | clk_div_falling;

endmodule