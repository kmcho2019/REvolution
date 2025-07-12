module TopModule (
    input in,       // Input signal
    output out      // Output signal (directly connected to input)
);
    // Direct wire connection - optimal PPA implementation
    assign out = in;
endmodule