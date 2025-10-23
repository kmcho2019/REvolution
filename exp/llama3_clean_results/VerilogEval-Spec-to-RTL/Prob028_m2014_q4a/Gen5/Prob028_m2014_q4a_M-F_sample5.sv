module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q = d;  // Using blocking assignment for level-sensitive latch
    end else begin
        q = q;  // Holding the current state when ena is low
    end
end

endmodule