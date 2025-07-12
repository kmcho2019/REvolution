module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // Shift register flip-flops
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register logic: shift right on clk posedge when enable
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

    // Wires to collect Q flip-flops
    wire [7:0] Q = {Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0};

    // 2-to-1 mux module
    function automatic mux2;
        input sel;
        input in0;
        input in1;
        begin
            mux2 = sel ? in1 : in0;
        end
    endfunction

    // Build hierarchical 8-to-1 mux using 2-to-1 mux stages
    wire [3:0] mux_level1;
    wire [1:0] mux_level2;
    wire mux_level3;

    // Level 1: 4 muxes selecting between pairs
    assign mux_level1[0] = mux2(C, Q[0], Q[1]);
    assign mux_level1[1] = mux2(C, Q[2], Q[3]);
    assign mux_level1[2] = mux2(C, Q[4], Q[5]);
    assign mux_level1[3] = mux2(C, Q[6], Q[7]);

    // Level 2: 2 muxes selecting between level1 outputs
    assign mux_level2[0] = mux2(B, mux_level1[0], mux_level1[1]);
    assign mux_level2[1] = mux2(B, mux_level1[2], mux_level1[3]);

    // Level 3: final mux selecting between level2 outputs
    assign mux_level3 = mux2(A, mux_level2[0], mux_level2[1]);

    assign Z = mux_level3;

endmodule