module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire path_a_1;
assign path_a_1 = 1'b1; // Constant 1 for when a is 1

wire path_a_0;
assign path_a_0 = ~b & c; // Logic for when a is 0

assign out = a? path_a_1 : path_a_0; // Multiplexer logic

endmodule