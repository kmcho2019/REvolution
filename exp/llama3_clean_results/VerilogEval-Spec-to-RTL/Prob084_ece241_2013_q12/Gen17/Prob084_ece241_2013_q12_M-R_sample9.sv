module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

always @(posedge clk) begin
    if (enable) begin
        Q0 <= S;
        Q1 <= Q0;
        Q2 <= Q1;
        Q3 <= Q2;
        Q4 <= Q3;
        Q5 <= Q4;
        Q6 <= Q5;
        Q7 <= Q6;
    end
end

assign Z = (A == 0 && B == 0 && C == 0) ? Q0 :
           (A == 0 && B == 0 && C == 1) ? Q1 :
           (A == 0 && B == 1 && C == 0) ? Q2 :
           (A == 0 && B == 1 && C == 1) ? Q3 :
           (A == 1 && B == 0 && C == 0) ? Q4 :
           (A == 1 && B == 0 && C == 1) ? Q5 :
           (A == 1 && B == 1 && C == 0) ? Q6 :
           (A == 1 && B == 1 && C == 1) ? Q7 : 1'bx;

endmodule