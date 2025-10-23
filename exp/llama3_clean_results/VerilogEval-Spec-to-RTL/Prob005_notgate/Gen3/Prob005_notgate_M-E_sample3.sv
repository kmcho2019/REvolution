module TopModule(
    input  in,
    output out
);

assign out = in ? 0 : 1;

// Alternatively, using a multiplexer (MUX) for educational purposes:
// assign out = in ? 0 : 1; can be seen as a MUX operation
// However, for clarity and sticking to the MUX idea:
// assign out = (in == 1'b0) ? 1'b1 : 1'b0;

// But to truly implement with a MUX (which is overkill for a NOT gate):
// assign out = (in == 1'b0) ? 1'b1 : (in == 1'b1) ? 1'b0 : 1'bx;

// The most straightforward MUX implementation for a NOT gate (though redundant):
assign out = in ? 0 : 1;

endmodule