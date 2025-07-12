module TopModule(input in, output wire out);
    // out is implicitly connected to in by the port declaration
    assign out = in;
endmodule