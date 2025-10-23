module TopModule (
    output zero
);
    // Implementing constant LOW using a mux structure
    // Both inputs are LOW, so select doesn't matter
    wire sel;  // Don't-care select signal
    assign zero = sel ? 1'b0 : 1'b0;
endmodule