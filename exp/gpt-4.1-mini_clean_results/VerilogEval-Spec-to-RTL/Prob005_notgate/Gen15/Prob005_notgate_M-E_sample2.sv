module GenericInverter #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    assign out = ~in;
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    GenericInverter #(.WIDTH(1)) inverter_inst (
        .in(in),
        .out(out)
    );
endmodule