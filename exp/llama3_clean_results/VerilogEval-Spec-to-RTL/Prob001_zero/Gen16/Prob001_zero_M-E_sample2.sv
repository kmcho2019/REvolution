module TopModule(
    output zero
);
    wire constant_one;
    assign constant_one = 1;
    assign zero = ~constant_one;
endmodule