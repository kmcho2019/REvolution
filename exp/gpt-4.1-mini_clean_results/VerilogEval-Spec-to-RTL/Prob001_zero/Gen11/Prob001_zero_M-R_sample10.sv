module TopModule(
    output zero
);
    wire zero_internal;
    assign zero_internal = 1'b0;
    assign zero = zero_internal;
endmodule