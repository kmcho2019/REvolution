module TopModule(
    output out
);
    wire internal_signal;
    assign internal_signal = 1;
    assign out = ~internal_signal;
endmodule