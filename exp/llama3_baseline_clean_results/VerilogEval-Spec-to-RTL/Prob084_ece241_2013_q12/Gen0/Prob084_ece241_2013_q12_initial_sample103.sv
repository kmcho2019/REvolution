module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// 8-bit shift register
reg [7:0] Q;
always @(posedge clk) begin
    if (enable) begin
        Q <= {S, Q[7:1]};
    end
end

// 8x1 multiplexer
assign Z = (A == 1'b0 && B == 1'b0 && C == 1'b0) ? Q[0] :
           (A == 1'b0 && B == 1'b0 && C == 1'b1) ? Q[1] :
           (A == 1'b0 && B == 1'b1 && C == 1'b0) ? Q[2] :
           (A == 1'b0 && B == 1'b1 && C == 1'b1) ? Q[3] :
           (A == 1'b1 && B == 1'b0 && C == 1'b0) ? Q[4] :
           (A == 1'b1 && B == 1'b0 && C == 1'b1) ? Q[5] :
           (A == 1'b1 && B == 1'b1 && C == 1'b0) ? Q[6] :
           (A == 1'b1 && B == 1'b1 && C == 1'b1) ? Q[7] : 1'bx;

endmodule