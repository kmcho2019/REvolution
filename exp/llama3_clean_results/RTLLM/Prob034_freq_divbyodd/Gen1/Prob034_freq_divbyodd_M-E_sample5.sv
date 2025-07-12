module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [31:0] cnt;
reg prev_clk;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        prev_clk <= 0;
        clk_div <= 0;
    end
    else begin
        prev_clk <= clk;
        cnt <= cnt + 1;
        if (cnt == (NUM_DIV - 1)) begin
            clk_div <= ~clk_div;
            cnt <= 0;
        end
    end
end

endmodule