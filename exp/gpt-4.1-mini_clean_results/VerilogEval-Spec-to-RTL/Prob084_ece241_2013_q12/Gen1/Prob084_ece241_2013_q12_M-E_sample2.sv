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

    // Multiplexer stage 1: pairs
    wire mux0 = (C == 1'b0) ? Q0 : Q1;
    wire mux1 = (C == 1'b0) ? Q2 : Q3;
    wire mux2 = (C == 1'b0) ? Q4 : Q5;
    wire mux3 = (C == 1'b0) ? Q6 : Q7;

    // Multiplexer stage 2: groups of four
    wire mux4 = (B == 1'b0) ? mux0 : mux1;
    wire mux5 = (B == 1'b0) ? mux2 : mux3;

    // Multiplexer stage 3: final mux selects between mux4 and mux5 by A
    assign Z = (A == 1'b0) ? mux4 : mux5;

endmodule