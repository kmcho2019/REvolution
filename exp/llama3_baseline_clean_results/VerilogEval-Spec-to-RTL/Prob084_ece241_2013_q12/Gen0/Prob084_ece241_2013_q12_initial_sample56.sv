module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

// 8-bit shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 3-to-1 multiplexer for each bit
wire Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
assign Q0 = (A == 0 && B == 0 && C == 0) ? Q[0] : 1'bz;
assign Q1 = (A == 0 && B == 0 && C == 1) ? Q[1] : 1'bz;
assign Q2 = (A == 0 && B == 1 && C == 0) ? Q[2] : 1'bz;
assign Q3 = (A == 0 && B == 1 && C == 1) ? Q[3] : 1'bz;
assign Q4 = (A == 1 && B == 0 && C == 0) ? Q[4] : 1'bz;
assign Q5 = (A == 1 && B == 0 && C == 1) ? Q[5] : 1'bz;
assign Q6 = (A == 1 && B == 1 && C == 0) ? Q[6] : 1'bz;
assign Q7 = (A == 1 && B == 1 && C == 1) ? Q[7] : 1'bz;

// 8-to-1 multiplexer to select the output
assign Z = Q0 | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 | Q7;

endmodule