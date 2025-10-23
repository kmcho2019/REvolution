module TopModule (
    input  in,    // Input signal
    output out    // Inverted output signal
);
    // Efficient NOT gate implementation using bitwise negation
    // This synthesizes to a single inverter with optimal PPA characteristics
    assign out = ~in;
endmodule