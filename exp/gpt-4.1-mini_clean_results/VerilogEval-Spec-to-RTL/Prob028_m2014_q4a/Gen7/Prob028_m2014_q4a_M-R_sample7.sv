module TopModule(
    input wire d,
    input wire ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;  // blocking assignment models transparent latch when ena=1
    // else hold previous q (no assignment)
end

endmodule