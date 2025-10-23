module TopModule (
    input        sel,      // Selection signal
    input  [7:0] a,       // First 8-bit input
    input  [7:0] b,       // Second 8-bit input
    output       out      // Selected bit output
);

    // Single-bit output 2-to-1 multiplexer
    // Selects between all bits of 'a' and 'b' using 'sel'
    // Outputs the OR of all selected bits (or could specify a particular bit)
    assign out = sel ? (|b) : (|a);  // OR reduction of selected input

    // Alternative implementation if specific bit selection is needed:
    // assign out = sel ? b[0] : a[0];  // Selects LSB of chosen input
endmodule