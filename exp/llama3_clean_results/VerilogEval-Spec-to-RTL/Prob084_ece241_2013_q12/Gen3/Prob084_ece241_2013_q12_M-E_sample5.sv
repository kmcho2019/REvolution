module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

assign Z = (Q[0] & ~A & ~B & ~C) |
           (Q[1] & ~A & ~B &  C)  |
           (Q[2] & ~A &  B & ~C)  |
           (Q[3] & ~A &  B &  C)  |
           (Q[4] &  A & ~B & ~C)  |
           (Q[5] &  A & ~B &  C)  |
           (Q[6] &  A &  B & ~C)  |
           (Q[7] &  A &  B &  C);

endmodule