module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Individual flip-flops for shift register bits
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register operation on clock's rising edge
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

    // 8-to-1 mux built as a hierarchy of 2-to-1 muxes controlled by C, B, then A
    wire mux0 = C ? Q1 : Q0;
    wire mux1 = C ? Q3 : Q2;
    wire mux2 = C ? Q5 : Q4;
    wire mux3 = C ? Q7 : Q6;

    wire mux4 = B ? mux1 : mux0;
    wire mux5 = B ? mux3 : mux2;

    assign Z = A ? mux5 : mux4;

endmodule