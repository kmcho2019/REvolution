module TopModule (
    input d,     // Data input
    input ena,   // Enable input (active high)
    output q     // Latched output
);

// D latch implementation:
// When ena=1, q follows d (transparent mode)
// When ena=0, q holds its previous value (latched mode)
assign q = ena ? d : q;

endmodule