module comparison_module(
    input  a,
    input  b,
    output out
);
    assign out = ~(a) ^ b;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                wire temp_out;
                comparison_module cmp(.a(i == 0 ? a : (i == 1 ? b : (i == 2 ? c : (i == 3 ? d : e))),
                                     .b(j == 0 ? a : (j == 1 ? b : (j == 2 ? c : (j == 3 ? d : e))),
                                     .out(temp_out));
                assign out[(i*5)+j] = temp_out;
            end
        end
    endgenerate

endmodule