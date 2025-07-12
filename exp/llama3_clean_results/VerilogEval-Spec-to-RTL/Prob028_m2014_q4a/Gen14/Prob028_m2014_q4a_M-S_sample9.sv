// TopModule: A D latch implementation
module TopModule(
    input  d,  // Data input
    input  ena, // Enable signal
    output reg q  // Output of the latch
);

// Continuous assignment to implement the D latch
// When ena is high, q follows d; when ena is low, q retains its value
assign q = (ena) ? d : q;

endmodule