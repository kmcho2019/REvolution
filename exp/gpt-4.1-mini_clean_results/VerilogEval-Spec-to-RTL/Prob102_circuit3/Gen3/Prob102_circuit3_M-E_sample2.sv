module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Combine inputs pairwise using AND gates
    wire ac_and = a & c;  // high if both a and c are high
    wire bd_and = b & d;  // high if both b and d are high

    // Output is 1 if either ac_and or bd_and is high
    assign q = ac_and | bd_and;

endmodule