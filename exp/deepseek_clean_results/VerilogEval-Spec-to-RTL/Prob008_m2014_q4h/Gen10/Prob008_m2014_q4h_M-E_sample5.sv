module TopModule (
    input in,
    output out
);
    // Implement as a 2:1 mux where select is always 1
    // This forces the mux to always choose input 'in'
    // The '0' input is a don't-care value
    assign out = (1'b1) ? in : 1'b0;
endmodule