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

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q_ones <= 4'd0;
        q_tens <= 4'd0;
        q_hundreds <= 4'd0;
        q_thousands <= 4'd0;
    end else begin
        ena[0] <= (q_ones == 4'd9)? 1'b1 : 1'b0;
        ena[1] <= (q_tens == 4'd9 && ena[0] == 1'b1)? 1'b1 : 1'b0;
        ena[2] <= (q_hundreds == 4'd9 && ena[1] == 1'b1 && ena[0] == 1'b1)? 1'b1 : 1'b0;
        
        if (ena[0] == 1'b1) begin
            q_ones <= 4'd0;
        end else if (q_ones!= 4'd9) begin
            q_ones <= q_ones + 1'b1;
        end
        
        if (ena[1] == 1'b1) begin
            q_tens <= 4'd0;
        end else if (q_ones == 4'd9 && ena[0] == 1'b1 && q_tens!= 4'd9) begin
            q_tens <= q_tens + 1'b1;
        end
        
        if (ena[2] == 1'b1) begin
            q_hundreds <= 4'd0;
        end else if (q_tens == 4'd9 && ena[1] == 1'b1 && q_hundreds!= 4'd9) begin
            q_hundreds <= q_hundreds + 1'b1;
        end
        
        if (q_hundreds == 4'd9 && ena[2] == 1'b1 && q_thousands!= 4'd9) begin
            q_thousands <= q_thousands + 1'b1;
        end else if (q_hundreds == 4'd9 && ena[2] == 1'b1 && q_thousands == 4'd9) begin
            q_thousands <= 4'd0;
        end
    end
end

endmodule