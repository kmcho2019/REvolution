module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Shift register bits
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register logic: shift left on enable, MSB gets S
    always @(posedge clk) begin
        if (enable) begin
            Q0 <= Q1;
            Q1 <= Q2;
            Q2 <= Q3;
            Q3 <= Q4;
            Q4 <= Q5;
            Q5 <= Q6;
            Q6 <= Q7;
            Q7 <= S;
        end
    end

    // 2:1 multiplexer primitive
    function automatic mux2to1;
        input sel;
        input d0, d1;
        begin
            mux2to1 = sel ? d1 : d0;
        end
    endfunction

    // Build 8:1 mux using 2:1 muxes in 3 stages
    wire mux_stage1_0, mux_stage1_1, mux_stage1_2, mux_stage1_3;
    wire mux_stage2_0, mux_stage2_1;
    wire mux_stage3_0;

    assign mux_stage1_0 = mux2to1(C, Q0, Q1);
    assign mux_stage1_1 = mux2to1(C, Q2, Q3);
    assign mux_stage1_2 = mux2to1(C, Q4, Q5);
    assign mux_stage1_3 = mux2to1(C, Q6, Q7);

    assign mux_stage2_0 = mux2to1(B, mux_stage1_0, mux_stage1_1);
    assign mux_stage2_1 = mux2to1(B, mux_stage1_2, mux_stage1_3);

    assign mux_stage3_0 = mux2to1(A, mux_stage2_0, mux_stage2_1);

    assign Z = mux_stage3_0;

endmodule