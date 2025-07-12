module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Internal shift register bits
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register: On clk posedge, if enable, shift in S to Q0 and shift each bit down
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

    // 2-to-1 mux module used for building the 8-to-1 mux
    wire mux_level1_0, mux_level1_1, mux_level1_2, mux_level1_3;
    wire mux_level2_0, mux_level2_1;
    wire mux_level3;

    // First level muxes: select between pairs of bits based on C (LSB of address)
    mux2to1 m0 (.sel(C), .in0(Q0), .in1(Q1), .out(mux_level1_0));
    mux2to1 m1 (.sel(C), .in0(Q2), .in1(Q3), .out(mux_level1_1));
    mux2to1 m2 (.sel(C), .in0(Q4), .in1(Q5), .out(mux_level1_2));
    mux2to1 m3 (.sel(C), .in0(Q6), .in1(Q7), .out(mux_level1_3));

    // Second level muxes: select between pairs from previous level based on B
    mux2to1 m4 (.sel(B), .in0(mux_level1_0), .in1(mux_level1_1), .out(mux_level2_0));
    mux2to1 m5 (.sel(B), .in0(mux_level1_2), .in1(mux_level1_3), .out(mux_level2_1));

    // Third level mux: select between the two results based on A (MSB of address)
    mux2to1 m6 (.sel(A), .in0(mux_level2_0), .in1(mux_level2_1), .out(mux_level3));

    // Output assignment
    assign Z = mux_level3;

endmodule

// 2-to-1 multiplexer module
module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule