module TopModule (
    input a,
    input b,
    output reg out
);
    // NOR gate implemented using always block
    always @(*) begin
        out = ~(a | b);
    end
endmodule