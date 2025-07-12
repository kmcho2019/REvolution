module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Directly assign 'a' or 'b' to 'out' based on 'sel' for simplicity and efficiency
    // The ternary operator is used, which is a good practice for this
    assign out = sel ? b : a;

endmodule