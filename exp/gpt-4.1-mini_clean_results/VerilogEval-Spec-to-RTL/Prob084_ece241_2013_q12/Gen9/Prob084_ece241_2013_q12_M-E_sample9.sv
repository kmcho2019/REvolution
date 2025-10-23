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

    // Shift register: shift in S into Q0, Q0->Q1, ..., Q6->Q7 on clk posedge if enable
    always @(posedge clk) begin
        if (enable) begin
            Q7 <= Q6;
            Q6 <= Q5;
            Q5 <= Q4;
            Q4 <= Q3;
            Q3 <= Q2;
            Q2 <= Q1;
            Q1 <= Q0;
            Q0 <= S;
        end
    end

    // Create 8-to-1 mux using hierarchical 2-to-1 muxes
    wire mux0_0 = (C) ? Q1 : Q0;
    wire mux0_1 = (C) ? Q3 : Q2;
    wire mux0_2 = (C) ? Q5 : Q4;
    wire mux0_3 = (C) ? Q7 : Q6;

    wire mux1_0 = (B) ? mux0_1 : mux0_0;
    wire mux1_1 = (B) ? mux0_3 : mux0_2;

    wire mux2_0 = (A) ? mux1_1 : mux1_0;

    assign Z = mux2_0;

endmodule