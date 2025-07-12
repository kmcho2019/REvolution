module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

// Simplified expression based on the Karnaugh map's logic
// Using a single OR gate for explicit optimization
assign out = a | b | c;

// Consider adding synthesis attributes or constraints for low power optimization
// Example (hypothetical, depends on the synthesis tool and technology library):
// (* power_optimization = "low_power" *) assign out = a | b | c;

endmodule