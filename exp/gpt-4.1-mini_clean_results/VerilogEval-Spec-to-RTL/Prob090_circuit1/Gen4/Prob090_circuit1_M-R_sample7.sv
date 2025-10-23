module TopModule (
    input  a,
    input  b,
    output reg q
);
    // Combinational logic implemented using always_comb block:
    // Output q is assigned based on the AND of inputs a and b.
    always @(*) begin
        q = a & b;
    end
endmodule