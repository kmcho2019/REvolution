module TopModule (
    output zero
);
// This module always outputs a LOW value on the 'zero' port.
// Explicitly assign a constant LOW value to the output port 'zero'
// This assignment ensures that the output 'zero' is always LOW, as required
assign zero = 1'b0;
endmodule