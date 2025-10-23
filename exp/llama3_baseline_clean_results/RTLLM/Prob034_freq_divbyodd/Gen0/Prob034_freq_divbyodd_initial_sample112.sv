module freq_divbyodd #(
    parameter NUM_DIV = 5  // default divisor value
)(
    input clk,            // input clock signal
    input rst_n,          // active low reset signal
    output clk_div        // divided clock output
);

reg [31:0] cnt1;          // counter for rising edges
reg [31:0] cnt2;          // counter for falling edges
reg clk_div1;             // clock divider for positive edges
reg clk_div2;             // clock divider for negative edges
reg prev_clk;             // previous clock value

always @(*) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else if (prev_clk!= clk) begin
        if (clk) begin  // rising edge
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end else begin  // falling edge
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

assign clk_div = clk_div1 | clk_div2;

endmodule