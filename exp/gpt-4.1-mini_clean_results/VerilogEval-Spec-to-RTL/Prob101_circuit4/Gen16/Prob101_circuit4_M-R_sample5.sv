module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output reg  q
);

    // Combinational logic in always_comb block for q = b | c
    always @(*) begin
        q = b | c;
    end

endmodule