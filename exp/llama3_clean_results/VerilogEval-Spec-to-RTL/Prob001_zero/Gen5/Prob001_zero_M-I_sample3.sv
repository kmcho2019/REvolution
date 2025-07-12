module TopModule (
    output reg zero // Explicitly define 'zero' as a reg type for clarity
);

always @(*) // This always block is not necessary but added for explicitness and flexibility for future changes
    zero = 1'b0;

endmodule