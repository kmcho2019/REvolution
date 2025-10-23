module TopModule(in1, in2, out);
    output out;
    input in1, in2;
    assign out = ~(in1 | in2);
endmodule