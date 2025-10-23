// TopModule: Always drives output 'one' high, improved for PPA.
module TopModule(
    output wire one // Explicitly define output as a wire
);

// Simple assignment to drive the output high.
assign one = 1'b1; // Direct constant assignment

endmodule