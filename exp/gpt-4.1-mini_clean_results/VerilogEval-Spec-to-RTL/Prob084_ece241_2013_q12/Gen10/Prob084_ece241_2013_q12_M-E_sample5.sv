module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // Individual flip-flops for shift register
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register logic: on clock edge with enable, shift bits
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

    // 8-to-1 multiplexer implemented as a mux tree
    wire mux_lvl1_0, mux_lvl1_1, mux_lvl1_2, mux_lvl1_3;
    wire mux_lvl2_0, mux_lvl2_1;
    wire mux_lvl3;

    // Level 1 muxes controlled by C
    assign mux_lvl1_0 = (C == 1'b0) ? Q0 : Q1;
    assign mux_lvl1_1 = (C == 1'b0) ? Q2 : Q3;
    assign mux_lvl1_2 = (C == 1'b0) ? Q4 : Q5;
    assign mux_lvl1_3 = (C == 1'b0) ? Q6 : Q7;

    // Level 2 muxes controlled by B
    assign mux_lvl2_0 = (B == 1'b0) ? mux_lvl1_0 : mux_lvl1_1;
    assign mux_lvl2_1 = (B == 1'b0) ? mux_lvl1_2 : mux_lvl1_3;

    // Level 3 mux controlled by A
    assign mux_lvl3 = (A == 1'b0) ? mux_lvl2_0 : mux_lvl2_1;

    assign Z = mux_lvl3;

endmodule