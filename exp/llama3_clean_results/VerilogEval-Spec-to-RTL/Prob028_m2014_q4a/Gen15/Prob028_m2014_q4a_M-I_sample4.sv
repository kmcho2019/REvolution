module TopModule(
    input  d,
    input  ena,
    output reg q
);
// Implement the D latch using an always block for clarity and synthesizability.
always @(*) begin
    if (ena) begin
        q <= d; // Use non-blocking assignment for sequential behavior.
    end else begin
        // In the absence of 'ena', the latch retains its current state.
        // The following line is not necessary but clarifies the intent.
        q <= q;
    end
end

endmodule