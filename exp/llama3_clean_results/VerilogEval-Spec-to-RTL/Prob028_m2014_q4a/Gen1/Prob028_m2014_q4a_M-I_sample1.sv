module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(*) begin
    if (ena) begin
        q = d; // Using blocking assignment for combinatorial logic
    end else begin
        // Do nothing, q retains its previous value
    end
end

endmodule