module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena) begin
        q <= d;  // Use non-blocking assignment to avoid race conditions
    end else begin
        q <= q;  // Hold the current state when ena is low
    end
end

endmodule