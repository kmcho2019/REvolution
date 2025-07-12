module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Individual D flip-flop registers for Q[0] to Q[7]
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register logic: on posedge clk if enable, shift in S at Q0, others shift right
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

    // Multiplexer stage 1: select between pairs based on C
    wire mux0 = C ? Q1 : Q0;
    wire mux1 = C ? Q3 : Q2;
    wire mux2 = C ? Q5 : Q4;
    wire mux3 = C ? Q7 : Q6;

    // Multiplexer stage 2: select between mux0,mux1 and mux2,mux3 based on B
    wire mux4 = B ? mux1 : mux0;
    wire mux5 = B ? mux3 : mux2;

    // Multiplexer stage 3: final output based on A
    assign Z = A ? mux5 : mux4;

endmodule