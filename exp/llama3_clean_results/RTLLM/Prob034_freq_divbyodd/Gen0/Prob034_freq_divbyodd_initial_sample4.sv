module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [31:0] cnt1, cnt2;
reg clk_div1, clk_div2;

always @(posedge clk or negedge clk) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        clk_div <= 0;
    end
    else begin
        if (clk) begin // rising edge
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end
        else begin // falling edge
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end
        clk_div <= clk_div1 | clk_div2;
    end
end

endmodule