module TopModule(
    input x,
    input y,
    output z
);

assign z = (x && y) || (!x && !y);

// Alternative implementation using a MUX
// assign z = (x ? y : !y) || (!x ? !y : y);
// Simplified MUX implementation
assign z = ~(x ^ y);

// Another way to implement using a MUX
// This implementation is not optimal, but it illustrates the idea
assign z = (x && y) || (!x && !y);

// Using a 2:1 MUX
//assign z = (x ? (y ? 1 : 0) : (!y ? 1 : 0));

endmodule