module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out,
    output reg out_n
);
    always @(*) begin
        // Calculate the output of the AND gates
        reg and_out1 = a & b;
        reg and_out2 = c & d;

        // Calculate the output of the OR gate
        out = and_out1 | and_out2;

        // Calculate the inverted output
        out_n = ~out;
    end
endmodule