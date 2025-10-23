module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // 8-bit shift register with synchronous enable
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

    // Decode ABC inputs to 8 one-hot signals
    wire [7:0] sel;
    assign sel[0] = ~A & ~B & ~C;
    assign sel[1] = ~A & ~B &  C;
    assign sel[2] = ~A &  B & ~C;
    assign sel[3] = ~A &  B &  C;
    assign sel[4] =  A & ~B & ~C;
    assign sel[5] =  A & ~B &  C;
    assign sel[6] =  A &  B & ~C;
    assign sel[7] =  A &  B &  C;

    // 8-to-1 multiplexer implemented with AND-OR logic
    wire z0 = Q0 & sel[0];
    wire z1 = Q1 & sel[1];
    wire z2 = Q2 & sel[2];
    wire z3 = Q3 & sel[3];
    wire z4 = Q4 & sel[4];
    wire z5 = Q5 & sel[5];
    wire z6 = Q6 & sel[6];
    wire z7 = Q7 & sel[7];

    assign Z = z0 | z1 | z2 | z3 | z4 | z5 | z6 | z7;

endmodule