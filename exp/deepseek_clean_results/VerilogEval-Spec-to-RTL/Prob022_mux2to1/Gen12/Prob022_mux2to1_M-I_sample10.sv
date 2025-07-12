module TopModule (
    input  wire a,       // First input signal
    input  wire b,       // Second input signal
    input  wire sel,     // Selection signal (0=a, 1=b)
    output wire out      // Output signal
);
    // 2-to-1 multiplexer implementation
    assign out = (sel == 1'b1) ? b : a;
endmodule