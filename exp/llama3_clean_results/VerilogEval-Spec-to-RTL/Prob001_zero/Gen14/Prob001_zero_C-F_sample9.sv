module TopModule (
    output zero
);
// Explicitly assign a constant LOW value to the output port 'zero'
// This assignment ensures that the output 'zero' is always LOW, as required
assign zero = 1'b0;
endmodule