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

    // Shift register flip-flops
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

    // 2-to-1 mux function
    function mux2;
        input sel;
        input d0, d1;
        begin
            mux2 = sel ? d1 : d0;
        end
    endfunction

    // Hierarchical mux tree to select one of Q[0..7]
    wire mux_level1_0, mux_level1_1, mux_level1_2, mux_level1_3;
    wire mux_level2_0, mux_level2_1;

    assign mux_level1_0 = mux2(C, Q0, Q1);  // Select between Q0,Q1
    assign mux_level1_1 = mux2(C, Q2, Q3);  // Select between Q2,Q3
    assign mux_level1_2 = mux2(C, Q4, Q5);  // Select between Q4,Q5
    assign mux_level1_3 = mux2(C, Q6, Q7);  // Select between Q6,Q7

    assign mux_level2_0 = mux2(B, mux_level1_0, mux_level1_1);
    assign mux_level2_1 = mux2(B, mux_level1_2, mux_level1_3);

    assign Z = mux2(A, mux_level2_0, mux_level2_1);

endmodule