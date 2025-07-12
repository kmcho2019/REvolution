module MUX2 (
    input  wire sel,
    input  wire d0,
    input  wire d1,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output wire f
);
    wire mux_lower_out;

    // Lower MUX: select = x2, inputs = 1 and x1
    // if x2=0 -> output 1, if x2=1 -> output x1
    MUX2 mux_lower (
        .sel(x2),
        .d0(1'b1),
        .d1(x1),
        .y(mux_lower_out)
    );

    // Upper MUX: select = x3, inputs = 0 and mux_lower_out
    // if x3=0 -> output 0, if x3=1 -> output mux_lower_out
    MUX2 mux_upper (
        .sel(x3),
        .d0(1'b0),
        .d1(mux_lower_out),
        .y(f)
    );
endmodule