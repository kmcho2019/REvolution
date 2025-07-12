module TopModule(
    input  a,
    input  b,
    output reg out
);
    // Implement 2-input NOR gate using always_comb procedural block
    always @(*) begin
        out = ~(a | b);
    end
endmodule