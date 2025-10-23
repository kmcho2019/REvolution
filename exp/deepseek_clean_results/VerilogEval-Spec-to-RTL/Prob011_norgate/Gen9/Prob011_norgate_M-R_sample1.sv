module TopModule(
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = ~(a | b);  // NOR operation using always block
    end
endmodule