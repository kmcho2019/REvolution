module TopModule (
    input d,
    input ena,
    output q
);

wire nor1_out, nor2_out;

nor (nor1_out, d, ena);
nor (nor2_out, nor1_out, q);
nor (q, ena, nor2_out);

endmodule