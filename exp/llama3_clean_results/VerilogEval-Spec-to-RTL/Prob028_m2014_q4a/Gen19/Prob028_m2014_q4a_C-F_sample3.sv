// TopModule: A D latch implementation using an always block
module TopModule(
    input  d,  // Data input
    input  ena, // Enable signal
    output reg q  // Output of the latch
);

// Always block to implement the D latch
// When ena is high, q follows d; when ena is low, q retains its value
always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule