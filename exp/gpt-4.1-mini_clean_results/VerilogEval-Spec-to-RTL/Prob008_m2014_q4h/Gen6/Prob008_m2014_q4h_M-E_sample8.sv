module TopModule(input in, output out);
    wire internal_wire;
    assign internal_wire = in;
    assign out = internal_wire;
endmodule