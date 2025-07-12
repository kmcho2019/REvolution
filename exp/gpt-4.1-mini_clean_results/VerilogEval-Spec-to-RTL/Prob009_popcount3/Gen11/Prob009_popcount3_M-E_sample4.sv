module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum01, carry01;
    wire sum_final, carry_final;

    // Sum and carry of first two bits
    assign sum01   = in[0] ^ in[1];
    assign carry01 = in[0] & in[1];

    // Sum and carry of sum01 and third bit
    assign sum_final   = sum01 ^ in[2];
    assign carry_final = sum01 & in[2];

    // Final output bits
    assign out[0] = sum_final;
    assign out[1] = carry01 | carry_final;

endmodule