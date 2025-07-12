module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    input  logic c,  // Input signal c
    input  logic d,  // Input signal d
    output logic out  // Output signal
);

    // Directly implement the logic based on the Karnaugh map
    // This involves identifying the specific conditions under which 'out' is 1
    assign out = (a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & ~b & ~c & d);

endmodule