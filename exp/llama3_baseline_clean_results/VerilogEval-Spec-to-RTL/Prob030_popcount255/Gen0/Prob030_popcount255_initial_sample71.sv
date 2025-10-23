module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Calculate the population count for each 16-bit chunk
    wire [3:0] chunk0, chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7, 
             chunk8, chunk9, chunk10, chunk11, chunk12, chunk13, chunk14, chunk15;

    // Population count for each chunk
    population_count #(.WIDTH(16)) pc0 (.in(in[15:0]), .out(chunk0));
    population_count #(.WIDTH(16)) pc1 (.in(in[31:16]), .out(chunk1));
    population_count #(.WIDTH(16)) pc2 (.in(in[47:32]), .out(chunk2));
    population_count #(.WIDTH(16)) pc3 (.in(in[63:48]), .out(chunk3));
    population_count #(.WIDTH(16)) pc4 (.in(in[79:64]), .out(chunk4));
    population_count #(.WIDTH(16)) pc5 (.in(in[95:80]), .out(chunk5));
    population_count #(.WIDTH(16)) pc6 (.in(in[111:96]), .out(chunk6));
    population_count #(.WIDTH(16)) pc7 (.in(in[127:112]), .out(chunk7));
    population_count #(.WIDTH(16)) pc8 (.in(in[143:128]), .out(chunk8));
    population_count #(.WIDTH(16)) pc9 (.in(in[159:144]), .out(chunk9));
    population_count #(.WIDTH(16)) pc10 (.in(in[175:160]), .out(chunk10));
    population_count #(.WIDTH(16)) pc11 (.in(in[191:176]), .out(chunk11));
    population_count #(.WIDTH(16)) pc12 (.in(in[207:192]), .out(chunk12));
    population_count #(.WIDTH(16)) pc13 (.in(in[223:208]), .out(chunk13));
    population_count #(.WIDTH(16)) pc14 (.in(in[239:224]), .out(chunk14));
    population_count #(.WIDTH(7)) pc15 (.in(in[254:248]), .out(chunk15));

    // Add counts using a tree-like structure
    wire [4:0] add0, add1, add2, add3, add4, add5, add6, add7;
    adder #(.WIDTH(4)) add0_unit (.in({chunk0, chunk1}), .out(add0));
    adder #(.WIDTH(4)) add1_unit (.in({chunk2, chunk3}), .out(add1));
    adder #(.WIDTH(4)) add2_unit (.in({chunk4, chunk5}), .out(add2));
    adder #(.WIDTH(4)) add3_unit (.in({chunk6, chunk7}), .out(add3));
    adder #(.WIDTH(4)) add4_unit (.in({chunk8, chunk9}), .out(add4));
    adder #(.WIDTH(4)) add5_unit (.in({chunk10, chunk11}), .out(add5));
    adder #(.WIDTH(4)) add6_unit (.in({chunk12, chunk13}), .out(add6));
    adder #(.WIDTH(4)) add7_unit (.in({chunk14, chunk15}), .out(add7));

    wire [5:0] add8, add9, add10, add11;
    adder #(.WIDTH(5)) add8_unit (.in({add0, add1}), .out(add8));
    adder #(.WIDTH(5)) add9_unit (.in({add2, add3}), .out(add9));
    adder #(.WIDTH(5)) add10_unit (.in({add4, add5}), .out(add10));
    adder #(.WIDTH(5)) add11_unit (.in({add6, add7}), .out(add11));

    wire [6:0] add12, add13;
    adder #(.WIDTH(6)) add12_unit (.in({add8, add9}), .out(add12));
    adder #(.WIDTH(6)) add13_unit (.in({add10, add11}), .out(add13));

    wire [7:0] add14;
    adder #(.WIDTH(7)) add14_unit (.in({add12, add13}), .out(add14));

    assign out = add14;

endmodule

// Population count module
module population_count #(
    parameter WIDTH = 16
)(
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    assign out = {1'b0, in[WIDTH-1:1]} + {1'b0, in[WIDTH-2:0]};

endmodule

// Adder module
module adder #(
    parameter WIDTH = 4
)(
    input [WIDTH-1:0] in,
    output [WIDTH:0] out
);

    assign out = in[WIDTH-1] + in[WIDTH-2:0];

endmodule