// TopModule: Always drives output 'one' high, using a NOT gate.
module TopModule(
    output one
);

// Internal signal tied to logic low.
wire internal_signal = 1'b0;

// Use a NOT gate to invert the internal signal, thus always driving 'one' high.
assign one = ~internal_signal;

endmodule