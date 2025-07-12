module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;   // Transparent latch when ena=1
    // else q keeps its value (latches)
end

endmodule