module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Using the ternary operator to select between 'a' and 'b' based on 'sel'
    assign out = (sel) ? b : a;

endmodule