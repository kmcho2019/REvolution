module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;
reg [2:0] cnt2;
reg clk_div1;
reg clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            clk_div1 <= ~clk_div1;
        end
        if (cnt2 == (NUM_DIV - 1) / 2) begin
            clk_div2 <= ~clk_div2;
        end
        cnt1 <= (cnt1 == (NUM_DIV - 1))? 0 : (cnt1 + 1);
        cnt2 <= (cnt2 == (NUM_DIV - 1))? 0 : (cnt2 + 1);
    end
end

always @(posedge clk_div1 or posedge clk_div2) begin
    clk_div <= (clk_div1 | clk_div2);
end

//To increment cnt1 at posedge and cnt2 at negedge
always @(posedge clk) begin
    if (cnt1!= (NUM_DIV - 1)) begin
        cnt1 <= cnt1 + 1;
    end else begin
        cnt1 <= 0;
    end
end

always @(negedge clk) begin
    if (cnt2!= (NUM_DIV - 1)) begin
        cnt2 <= cnt2 + 1;
    end else begin
        cnt2 <= 0;
    end
end

endmodule