module TopModule (
    input  a,
    input  b,
    output reg q
);

    // Combinational logic using always_comb block
    always @(*) begin
        q = a & b;
    end

endmodule