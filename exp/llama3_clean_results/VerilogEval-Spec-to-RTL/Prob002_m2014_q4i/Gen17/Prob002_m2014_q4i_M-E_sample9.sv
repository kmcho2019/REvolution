module TopModule(
    output out
);
    reg internal_signal;
    assign internal_signal = 1'b1;
    assign out = internal_signal & 1'b0;
endmodule