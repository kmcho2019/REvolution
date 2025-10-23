module TopModule(
    output zero
);
    // Directly assign a constant LOW value to the output port 'zero'
    wire zero; // Use wire instead of reg for combinational logic
    assign zero = 1'b0;
endmodule