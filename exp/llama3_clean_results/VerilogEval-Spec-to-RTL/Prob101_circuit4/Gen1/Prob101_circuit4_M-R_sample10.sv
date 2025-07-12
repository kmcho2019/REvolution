module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

wire bc_or; // Temporary wire to hold the result of b OR c

assign bc_or = b || c; // Calculate b OR c
assign q = bc_or || (a && bc_or); // Use the temporary wire in the final expression

endmodule