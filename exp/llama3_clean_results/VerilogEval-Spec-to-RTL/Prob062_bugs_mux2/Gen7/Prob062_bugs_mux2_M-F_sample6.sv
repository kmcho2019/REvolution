module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Use the ternary operator to select between 'a' and 'b' based on 'sel'.
    // This ensures the output is correctly vectorized and selected based on the 'sel' signal.
    assign out = (sel)? b : a;

    // Alternatively, for explicit bit-level control, the following could be used,
    // but it's less concise and should behave the same as the ternary operator in terms of functionality.
    // assign out = {8{(sel)? b[7] : a[7], (sel)? b[6] : a[6], (sel)? b[5] : a[5], (sel)? b[4] : a[4], (sel)? b[3] : a[3], (sel)? b[2] : a[2], (sel)? b[1] : a[1], (sel)? b[0] : a[0]}};

endmodule