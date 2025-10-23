module TopModule (
    input  x,
    input  y,
    output z
);
    // Local functions for clarity and modularity without instantiation overhead
    function automatic logic xor2(input logic a, input logic b);
        xor2 = a ^ b;
    endfunction

    function automatic logic and2(input logic a, input logic b);
        and2 = a & b;
    endfunction

    // Direct continuous assignment implementing z = (x ^ y) & x
    assign z = and2(xor2(x, y), x);

endmodule