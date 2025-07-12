module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement a 2-to-1 multiplexer using basic logical operations.
// When sel = 0, select input a; when sel = 1, select input b.
wire sel_bar; // Inverse of sel
assign sel_bar = ~sel; // Calculate the inverse of sel

assign out = (a & sel_bar) | (b & sel); // Select a or b based on sel
endmodule