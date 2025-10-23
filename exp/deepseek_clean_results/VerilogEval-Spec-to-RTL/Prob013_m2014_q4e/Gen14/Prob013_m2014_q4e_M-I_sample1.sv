module TopModule (
    input wire in1,
    input wire in2,
    output wire out
);
    // Behavioral implementation (optimal for most cases)
    assign out = ~(in1 | in2);
    
    // Alternative: Technology-specific instantiation
    // NOR2X1 U1 (.A(in1), .B(in2), .Y(out));
endmodule