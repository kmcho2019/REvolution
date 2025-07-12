module TopModule(
    input  d,
    input  ena,
    output reg q
);

// Simplified D latch implementation with explicit sensitivity list
always @(d, ena) begin
    if (ena) begin
        q <= d;
    end
end

endmodule