module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    // Declare individual flip-flops Q[0]..Q[7]
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // On rising edge of clk, shift register logic
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

    // Build 2-to-1 multiplexers for selecting the output based on inputs A, B, C

    // Level 1 muxes selecting pairs based on C
    wire mux0 = C ? Q1 : Q0;  // select Q0 or Q1
    wire mux1 = C ? Q3 : Q2;  // select Q2 or Q3
    wire mux2 = C ? Q5 : Q4;  // select Q4 or Q5
    wire mux3 = C ? Q7 : Q6;  // select Q6 or Q7

    // Level 2 muxes selecting pairs based on B
    wire mux4 = B ? mux1 : mux0; // select between mux0 and mux1
    wire mux5 = B ? mux3 : mux2; // select between mux2 and mux3

    // Level 3 mux selecting final output based on A
    assign Z = A ? mux5 : mux4;

endmodule