module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Declare individual flip-flop outputs
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register flip-flops - each triggered on clk posedge
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

    // Decode ABC to select one of Q0-Q7
    wire [7:0] sel_dec;
    assign sel_dec = 8'b00000001 << ({A, B, C});

    // Multiplexer logic: output Z is OR of Q[i] & sel_dec[i]
    assign Z = (Q0 & sel_dec[0]) |
               (Q1 & sel_dec[1]) |
               (Q2 & sel_dec[2]) |
               (Q3 & sel_dec[3]) |
               (Q4 & sel_dec[4]) |
               (Q5 & sel_dec[5]) |
               (Q6 & sel_dec[6]) |
               (Q7 & sel_dec[7]);

endmodule