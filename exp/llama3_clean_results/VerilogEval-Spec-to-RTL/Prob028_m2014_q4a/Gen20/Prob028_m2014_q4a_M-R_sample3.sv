// TopModule: A D latch implementation using an always block
module TopModule(
    input  d,  // Data input
    input  ena, // Enable signal
    output reg q  // Output of the latch
);

// Always block to implement the D latch
always @(*) begin
    // When ena is high, q follows d; when ena is low, q retains its value
    if (ena) begin
        q = d;
    end else begin
        // No need to do anything here as q will retain its value
    end
end

endmodule