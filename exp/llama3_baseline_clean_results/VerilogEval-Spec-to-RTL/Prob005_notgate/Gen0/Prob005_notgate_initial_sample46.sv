module TopModule(
    input  in,
    output out
);

assign out = ~in; // The ~ operator inverts the input signal

endmodule