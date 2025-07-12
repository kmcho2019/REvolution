module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Ensure the output is properly assigned based on the select signal
    // The logic here should directly assign 'a' or 'b' to 'out' based on 'sel'
    // The use of the ternary operator is already a good practice for this
    assign out = sel ? b : a;

endmodule