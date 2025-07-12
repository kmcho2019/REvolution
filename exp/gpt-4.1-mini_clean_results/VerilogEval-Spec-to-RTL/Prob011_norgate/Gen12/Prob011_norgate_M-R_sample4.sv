module TopModule (
    input  a,
    input  b,
    output reg out
);

    // Implement 2-input NOR gate using behavioral combinational always block
    always @(*) begin
        out = ~(a | b);
    end

endmodule