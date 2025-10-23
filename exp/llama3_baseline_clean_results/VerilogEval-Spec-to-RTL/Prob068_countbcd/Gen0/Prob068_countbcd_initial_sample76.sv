module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones;
reg [3:0] q_tens;
reg [3:0] q_hundreds;
reg [3:0] q_thousands;

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

always @(posedge clk) begin
    if (reset) begin
        q_ones <= 0;
        q_tens <= 0;
        q_hundreds <= 0;
        q_thousands <= 0;
    end else begin
        reg inc_tens;
        reg inc_hundreds;
        reg inc_thousands;
        
        inc_tens = (q_ones == 9) ? 1'b1 : 1'b0;
        inc_hundreds = (q_tens == 9 && inc_tens) ? 1'b1 : 1'b0;
        inc_thousands = (q_hundreds == 9 && inc_hundreds) ? 1'b1 : 1'b0;

        assign ena = {inc_thousands, inc_hundreds, inc_tens};

        q_ones <= (q_ones == 9) ? 0 : q_ones + 1;
        q_tens <= (inc_tens) ? (q_tens == 9) ? 0 : q_tens + 1 : q_tens;
        q_hundreds <= (inc_hundreds) ? (q_hundreds == 9) ? 0 : q_hundreds + 1 : q_hundreds;
        q_thousands <= (inc_thousands) ? (q_thousands == 9) ? 0 : q_thousands + 1 : q_thousands;
    end
end

endmodule