module TopModule(
    input wire d,
    input wire ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q <= d; // nonblocking assignment models latch transparent when ena=1
    // else: no assignment, latch holds previous q
end

endmodule