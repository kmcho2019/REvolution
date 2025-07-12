module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt_rising;
reg [31:0] cnt_falling;
reg        clk_div1;
reg        clk_div2;

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (clk) begin // Rising edge
            if (cnt_rising == (NUM_DIV - 1) / 2) begin
                cnt_rising <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt_rising <= cnt_rising + 1;
            end
        end else begin // Falling edge
            if (cnt_falling == (NUM_DIV - 1) / 2) begin
                cnt_falling <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt_falling <= cnt_falling + 1;
            end
        end
    end
end

endmodule