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

    // Shift register: shift in S at Q0, shift right through Q7
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

    // 8-to-1 mux using nested conditional operator, select by {A,B,C}
    assign Z = ( {A,B,C} == 3'b000 ) ? Q0 :
               ( {A,B,C} == 3'b001 ) ? Q1 :
               ( {A,B,C} == 3'b010 ) ? Q2 :
               ( {A,B,C} == 3'b011 ) ? Q3 :
               ( {A,B,C} == 3'b100 ) ? Q4 :
               ( {A,B,C} == 3'b101 ) ? Q5 :
               ( {A,B,C} == 3'b110 ) ? Q6 :
                                       Q7;

endmodule