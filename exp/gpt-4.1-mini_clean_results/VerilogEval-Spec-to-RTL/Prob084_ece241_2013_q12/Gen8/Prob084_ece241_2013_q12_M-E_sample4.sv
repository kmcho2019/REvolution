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

    wire mux0_0 = C ? Q1 : Q0;
    wire mux0_1 = C ? Q3 : Q2;
    wire mux0_2 = C ? Q5 : Q4;
    wire mux0_3 = C ? Q7 : Q6;

    wire mux1_0 = B ? mux0_1 : mux0_0;
    wire mux1_1 = B ? mux0_3 : mux0_2;

    assign Z = A ? mux1_1 : mux1_0;

endmodule