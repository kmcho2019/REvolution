// TopModule: A simplified D latch implementation
module TopModule(
    input  d,  // Data input
    input  ena, // Enable signal
    output reg q  // Output of the latch
);

// Always block to implement the D latch
always @(*) begin
    if (ena) begin
        q <= d;
    end else begin
        q <= q;
    end
end

endmodule