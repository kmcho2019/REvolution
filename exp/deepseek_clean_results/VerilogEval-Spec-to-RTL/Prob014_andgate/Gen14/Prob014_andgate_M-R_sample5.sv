module TopModule(
    input a,
    input b,
    output reg out
);
    // Refactored using always block
    always @(*) begin
        out = a & b;
    end
endmodule