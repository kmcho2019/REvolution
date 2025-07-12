module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(ena or d) begin
    if (ena)
        q = d;
    // else q holds its value implicitly, inferring a latch
end

endmodule