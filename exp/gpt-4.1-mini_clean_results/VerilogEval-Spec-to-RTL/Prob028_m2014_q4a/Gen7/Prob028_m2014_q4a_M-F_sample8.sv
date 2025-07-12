module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @* begin
    if (ena)
        q = d;
    // else no assignment, so q holds its previous value (latch behavior)
end

endmodule