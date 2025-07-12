// Module TopModule implements a 2-1 multiplexer using a hierarchical tree-like structure.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    input [99:0] a,  // 100-bit input 'a'
    input [99:0] b,  // 100-bit input 'b'
    input sel,       // select line
    output [99:0] out // 100-bit output
);

// Define a recursive multiplexer module for smaller chunks.
module mux2to1_chunk(
    input [7:0] a,  // 8-bit chunk of 'a'
    input [7:0] b,  // 8-bit chunk of 'b'
    input sel,      // select line
    output [7:0] out // 8-bit output
);
    assign out = (sel == 0) ? a : b;
endmodule

// Divide the 100-bit inputs into 12 chunks of 8 bits each (with 4 bits left over).
// Use the hierarchical multiplexer structure to select between these chunks.
mux2to1_chunk chunk0(
    .a(a[7:0]),  // chunk 0 of 'a'
    .b(b[7:0]),  // chunk 0 of 'b'
    .sel(sel),   // select line
    .out(out[7:0]) // chunk 0 of output
);

mux2to1_chunk chunk1(
    .a(a[15:8]), // chunk 1 of 'a'
    .b(b[15:8]), // chunk 1 of 'b'
    .sel(sel),   // select line
    .out(out[15:8]) // chunk 1 of output
);

mux2to1_chunk chunk2(
    .a(a[23:16]), // chunk 2 of 'a'
    .b(b[23:16]), // chunk 2 of 'b'
    .sel(sel),   // select line
    .out(out[23:16]) // chunk 2 of output
);

mux2to1_chunk chunk3(
    .a(a[31:24]), // chunk 3 of 'a'
    .b(b[31:24]), // chunk 3 of 'b'
    .sel(sel),   // select line
    .out(out[31:24]) // chunk 3 of output
);

mux2to1_chunk chunk4(
    .a(a[39:32]), // chunk 4 of 'a'
    .b(b[39:32]), // chunk 4 of 'b'
    .sel(sel),   // select line
    .out(out[39:32]) // chunk 4 of output
);

mux2to1_chunk chunk5(
    .a(a[47:40]), // chunk 5 of 'a'
    .b(b[47:40]), // chunk 5 of 'b'
    .sel(sel),   // select line
    .out(out[47:40]) // chunk 5 of output
);

mux2to1_chunk chunk6(
    .a(a[55:48]), // chunk 6 of 'a'
    .b(b[55:48]), // chunk 6 of 'b'
    .sel(sel),   // select line
    .out(out[55:48]) // chunk 6 of output
);

mux2to1_chunk chunk7(
    .a(a[63:56]), // chunk 7 of 'a'
    .b(b[63:56]), // chunk 7 of 'b'
    .sel(sel),   // select line
    .out(out[63:56]) // chunk 7 of output
);

mux2to1_chunk chunk8(
    .a(a[71:64]), // chunk 8 of 'a'
    .b(b[71:64]), // chunk 8 of 'b'
    .sel(sel),   // select line
    .out(out[71:64]) // chunk 8 of output
);

mux2to1_chunk chunk9(
    .a(a[79:72]), // chunk 9 of 'a'
    .b(b[79:72]), // chunk 9 of 'b'
    .sel(sel),   // select line
    .out(out[79:72]) // chunk 9 of output
);

mux2to1_chunk chunk10(
    .a(a[87:80]), // chunk 10 of 'a'
    .b(b[87:80]), // chunk 10 of 'b'
    .sel(sel),   // select line
    .out(out[87:80]) // chunk 10 of output
);

mux2to1_chunk chunk11(
    .a(a[95:88]), // chunk 11 of 'a'
    .b(b[95:88]), // chunk 11 of 'b'
    .sel(sel),   // select line
    .out(out[95:88]) // chunk 11 of output
);

// Handle the remaining 4 bits (96-99) separately.
assign out[99:96] = (sel == 0) ? a[99:96] : b[99:96];

endmodule