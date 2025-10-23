module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
reg [2:0] ena;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        q_ones <= 4'd0;
        q_tens <= 4'd0;
        q_hundreds <= 4'd0;
        q_thousands <= 4'd0;
    end else begin
        q_ones <= q_ones + 1;
        ena[0] <= (q_ones == 4'd9) ? 1'b1 : 1'b0;
        if(ena[0]) begin
            q_tens <= q_tens + 1;
            q_ones <= 4'd0;
        end
        ena[1] <= (q_tens == 4'd9) ? 1'b1 : 1'b0;
        if(ena[1]) begin
            q_hundreds <= q_hundreds + 1;
            q_tens <= 4'd0;
        end
        ena[2] <= (q_hundreds == 4'd9) ? 1'b1 : 1'b0;
        if(ena[2]) begin
            q_thousands <= q_thousands + 1;
            q_hundreds <= 4'd0;
        end
    end
end

assign q = {q_thousands, q_hundreds, q_tens, q_ones};

endmodule