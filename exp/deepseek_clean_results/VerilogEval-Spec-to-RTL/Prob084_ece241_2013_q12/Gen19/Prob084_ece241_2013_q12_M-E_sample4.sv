module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Clock gating
    wire gated_clk;
    assign gated_clk = clk & enable;

    // Individual flip-flops for the shift register
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
    
    always @(posedge gated_clk) begin
        Q0 <= S;
        Q1 <= Q0;
        Q2 <= Q1;
        Q3 <= Q2;
        Q4 <= Q3;
        Q5 <= Q4;
        Q6 <= Q5;
        Q7 <= Q6;
    end

    // 3-to-8 decoder
    wire [7:0] decoder_out;
    assign decoder_out[0] = ~A & ~B & ~C;
    assign decoder_out[1] = ~A & ~B &  C;
    assign decoder_out[2] = ~A &  B & ~C;
    assign decoder_out[3] = ~A &  B &  C;
    assign decoder_out[4] =  A & ~B & ~C;
    assign decoder_out[5] =  A & ~B &  C;
    assign decoder_out[6] =  A &  B & ~C;
    assign decoder_out[7] =  A &  B &  C;

    // Output selection logic
    assign Z = (Q0 & decoder_out[0]) |
               (Q1 & decoder_out[1]) |
               (Q2 & decoder_out[2]) |
               (Q3 & decoder_out[3]) |
               (Q4 & decoder_out[4]) |
               (Q5 & decoder_out[5]) |
               (Q6 & decoder_out[6]) |
               (Q7 & decoder_out[7]);
endmodule