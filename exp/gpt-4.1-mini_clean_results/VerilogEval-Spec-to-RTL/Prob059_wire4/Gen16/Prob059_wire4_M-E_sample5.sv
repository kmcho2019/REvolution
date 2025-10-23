module Mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Internal wire bus
    wire [1:0] bus;
    assign bus[0] = b;
    assign bus[1] = c;

    // Constant selects (0 or 1)
    localparam SEL0 = 1'b0;
    localparam SEL1 = 1'b1;

    // Use muxes with fixed selects to route signals
    Mux2to1 mux_w (.sel(SEL0), .in0(a),    .in1(1'b0), .out(w)); // a -> w
    Mux2to1 mux_x (.sel(SEL0), .in0(bus[0]), .in1(1'b0), .out(x)); // b -> x
    Mux2to1 mux_y (.sel(SEL0), .in0(bus[0]), .in1(1'b0), .out(y)); // b -> y
    Mux2to1 mux_z (.sel(SEL1), .in0(1'b0), .in1(bus[1]), .out(z)); // c -> z

endmodule