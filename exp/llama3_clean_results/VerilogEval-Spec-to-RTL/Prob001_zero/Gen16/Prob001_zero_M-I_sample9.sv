// TopModule with a single output port that always outputs a LOW signal.
module TopModule (
    output zero
);
    // Directly assign a constant LOW value to the output port.
    assign zero = 1'b0;
endmodule