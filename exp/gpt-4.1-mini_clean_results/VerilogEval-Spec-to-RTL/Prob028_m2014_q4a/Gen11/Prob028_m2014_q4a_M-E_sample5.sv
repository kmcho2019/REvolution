module TopModule(
    input wire d,
    input wire ena,
    output reg q
);
    always @(ena or d) begin
        if (ena)
            q <= d;    // Transparent mode: latch input
        else
            q <= q;    // Hold mode: retain value
    end
endmodule