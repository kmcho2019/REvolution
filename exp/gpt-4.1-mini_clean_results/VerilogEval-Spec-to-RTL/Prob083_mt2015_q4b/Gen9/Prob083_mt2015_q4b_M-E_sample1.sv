module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    wire not_x;
    assign not_x = ~x;
    // When y=0, z = ~x; when y=1, z = 1
    assign z = y ? 1'b1 : not_x;
endmodule