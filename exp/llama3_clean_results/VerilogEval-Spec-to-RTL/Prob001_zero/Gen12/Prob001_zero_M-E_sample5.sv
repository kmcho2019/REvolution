module TopModule(
    output zero
);
    logic constant_input;
    assign constant_input = 1'b1;
    assign zero = ~constant_input;
endmodule