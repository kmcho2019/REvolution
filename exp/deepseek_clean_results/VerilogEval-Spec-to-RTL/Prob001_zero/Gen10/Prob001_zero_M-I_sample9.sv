module TopModule (
    output zero  // Constant LOW output
);
    parameter CONSTANT_LOW = 1'b0;  // Explicitly named constant
    assign zero = CONSTANT_LOW;     // Clear intent for constant LOW output
endmodule