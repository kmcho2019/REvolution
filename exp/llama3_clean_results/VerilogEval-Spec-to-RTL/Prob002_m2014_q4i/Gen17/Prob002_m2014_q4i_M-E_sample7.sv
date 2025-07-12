module TopModule(
    output out
);
    wire internal_signal;
    assign internal_signal = 1'b1; // Constant '1'
    assign out = ~internal_signal; // Inverter: 1 -> 0, 0 -> 1
endmodule