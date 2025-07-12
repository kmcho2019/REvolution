module TopModule (
    output zero
);
    // Explicitly define the output as a wire for clarity
    wire zero;
    // Explicitly assign a constant LOW value to the output port 'zero'
    assign zero = 1'b0;
endmodule