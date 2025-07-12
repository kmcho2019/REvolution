module TopModule (
    output zero
);
// Explicitly assign a constant LOW value to the output port 'zero'
// This output is a constant and should be optimized for low power and area
assign zero = 1'b0;
endmodule