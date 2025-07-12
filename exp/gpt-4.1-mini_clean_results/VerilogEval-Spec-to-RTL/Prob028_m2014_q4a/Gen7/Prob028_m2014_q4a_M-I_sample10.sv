module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @* begin
    if (ena)
        q = d;
    // else no assignment, q retains its previous value (latch inferred)
end

endmodule