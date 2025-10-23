module TopModule(
    input  a,
    input  b,
    output reg out
);

    always @(*) begin
        out = ~(a ^ b);  // XNOR operation implemented procedurally
    end

endmodule