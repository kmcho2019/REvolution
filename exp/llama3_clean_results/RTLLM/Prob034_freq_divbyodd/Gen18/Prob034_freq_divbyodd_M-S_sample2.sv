module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

logic [$clog2(NUM_DIV-1):0] cnt_rising;
logic [$clog2(NUM_DIV-1):0] cnt_falling;
logic clk_div1;
logic clk_div2;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (clk == 1'b1) begin
            if (cnt_rising == (NUM_DIV - 1)) begin
                cnt_rising <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt_rising <= cnt_rising + 1;
            end
        end else if (clk == 1'b0) begin
            if (cnt_falling == (NUM_DIV - 1)) begin
                cnt_falling <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt_falling <= cnt_falling + 1;
            end
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule