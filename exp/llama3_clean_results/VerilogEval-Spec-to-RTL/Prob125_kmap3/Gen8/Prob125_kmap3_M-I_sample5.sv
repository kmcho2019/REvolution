module TopModule(
    input  a,
    input  b,
    input  c,
    // 'd' is don't-care, not used in the logic, and thus omitted for simplicity
    output out
);

// Alternative implementation focusing on simplicity and direct mapping of the Karnaugh map
assign out = (a) | ((~a) & (~b) & c);

// This implementation maintains the essential conditions for 'out' to be 1, directly derived from the Karnaugh map
// By using bitwise operations and simplifying the logic, we aim to optimize the design for better PPA metrics

endmodule