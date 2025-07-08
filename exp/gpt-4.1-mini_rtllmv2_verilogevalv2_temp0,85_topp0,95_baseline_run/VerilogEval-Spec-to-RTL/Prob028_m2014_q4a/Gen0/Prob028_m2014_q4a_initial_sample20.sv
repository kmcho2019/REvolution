module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // else q holds its previous value because q is reg and not assigned
end

endmodule