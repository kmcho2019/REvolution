module TopModule(
    input x,
    input y,
    output z
);

// Alternative implementation using a different logical expression
// The idea here is to explore if an equivalent expression could lead to a more efficient implementation
// However, given the simplicity of the original expression and the basic nature of the operations involved,
// significant improvements are unlikely without specific synthesis tool optimizations.

assign z = x & (~x ^ y);

endmodule