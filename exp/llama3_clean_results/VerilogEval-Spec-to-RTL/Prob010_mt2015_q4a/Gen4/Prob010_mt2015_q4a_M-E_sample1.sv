module TopModule(
    input x,
    input y,
    output z
);

// Directly implementing the XOR and AND operations as per the original function
// But considering a different ordering or logic minimization techniques
assign z = x && (x !== y);

endmodule