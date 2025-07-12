module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q_ones, q_tens, q_hundreds, q_thousands;
wire [3:0] next_q_ones, next_q_tens, next_q_hundreds, next_q_thousands;

assign next_q_ones = (reset)? 4'd0 : 
                     (q_ones == 4'd9)? 4'd0 : 
                     (q_ones == 4'd9 && ena[0] == 1'b1)? 4'd0 : 
                     q_ones + 4'd1;

assign next_q_tens = (reset)? 4'd0 : 
                     (q_ones == 4'd9 && q_tens!= 4'd9)? q_tens + 4'd1 : 
                     (q_ones == 4'd9 && q_tens == 4'd9)? 4'd0 : 
                     q_tens;

assign next_q_hundreds = (reset)? 4'd0 : 
                         (q_tens == 4'd9 && q_hundreds!= 4'd9 && q_ones == 4'd0)? q_hundreds + 4'd1 : 
                         (q_tens == 4'd9 && q_hundreds == 4'd9 && q_ones == 4'd0)? 4'd0 : 
                         q_hundreds;

assign next_q_thousands = (reset)? 4'd0 : 
                         (q_hundreds == 4'd9 && q_thousands!= 4'd9 && q_tens == 4'd0 && q_ones == 4'd0)? q_thousands + 4'd1 : 
                         (q_hundreds == 4'd9 && q_thousands == 4'd9 && q_tens == 4'd0 && q_ones == 4'd0)? 4'd0 : 
                         q_thousands;

assign ena[0] = (q_ones == 4'd9)? 1'b1 : 1'b0;
assign ena[1] = (q_tens == 4'd9 && q_ones == 4'd0)? 1'b1 : 1'b0;
assign ena[2] = (q_hundreds == 4'd9 && q_tens == 4'd0 && q_ones == 4'd0)? 1'b1 : 1'b0;

always @(posedge clk) begin
    if(reset) begin
        q_ones <= 4'd0;
        q_tens <= 4'd0;
        q_hundreds <= 4'd0;
        q_thousands <= 4'd0;
    end else begin
        q_ones <= next_q_ones;
        q_tens <= next_q_tens;
        q_hundreds <= next_q_hundreds;
        q_thousands <= next_q_thousands;
    end
end

assign q[3:0] = q_ones;
assign q[7:4] = q_tens;
assign q[11:8] = q_hundreds;
assign q[15:12] = q_thousands;

endmodule