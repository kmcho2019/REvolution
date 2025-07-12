module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
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

    wire [7:0] Q_vec = {Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0};

    // Multiplexer implemented via nested conditional operator
    // Map ABC to 0 to 7 decimal selection
    wire [2:0] sel = {A, B, C};

    assign Z = (sel == 3'b000) ? Q0 :
               (sel == 3'b001) ? Q1 :
               (sel == 3'b010) ? Q2 :
               (sel == 3'b011) ? Q3 :
               (sel == 3'b100) ? Q4 :
               (sel == 3'b101) ? Q5 :
               (sel == 3'b110) ? Q6 :
                                 Q7;

endmodule