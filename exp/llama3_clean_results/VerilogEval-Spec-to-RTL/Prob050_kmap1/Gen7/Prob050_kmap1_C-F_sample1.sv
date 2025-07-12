module TopModule(
    input a,
    input b,
    input c,
    output logic out
);

// Directly use the OR operation to combine the inputs, as it represents the most straightforward and efficient implementation of the Karnaugh map's logic.
assign out = a || b || c;

endmodule