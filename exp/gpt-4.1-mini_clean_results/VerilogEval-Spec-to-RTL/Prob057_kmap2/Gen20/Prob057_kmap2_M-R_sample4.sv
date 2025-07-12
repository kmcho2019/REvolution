module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Output defined as a single combinational expression using ternary operators,
    // directly encoding the minimized function from the K-map.
    assign out =
        ( (~c & ~d) & (~a | ~b) )  // group covering nc&nd&(~a|~b)
      | ( (~c & d) & ~b )          // nc&d&nb
      | ( c & ~d & ~a )            // c&nd&na
      | ( c & d & (a | b) );       // c&d&(a|b)
endmodule