module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// Define the two logic paths
wire path1;
assign path1 = 1'b1; // When 'a' is 1, output is always 1

wire path2;
assign path2 = ~b & c; // When 'a' is 0, output depends on 'b' and 'c'

// Use a multiplexer to switch between the two logic paths
assign out = a? path1 : path2;

endmodule