module TopModule (
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena)
        q = d;
    // No else branch: q keeps its previous value, inferring a latch
end

endmodule