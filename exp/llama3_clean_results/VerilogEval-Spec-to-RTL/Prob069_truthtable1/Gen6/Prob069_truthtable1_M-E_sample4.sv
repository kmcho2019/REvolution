module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using a 2:1 MUX architecture to implement the logic.
// The selection line is x3, and based on its value, either x2 or x1 is selected.
assign f = (x3) ? x1 : x2;

endmodule