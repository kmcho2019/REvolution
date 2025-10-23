module TopModule (
    output one
);
    // Implement constant 1 using an OR gate with one input tied high
    or(one, 1'b1, 1'b0);  // OR operation between 1 and 0 always yields 1
endmodule