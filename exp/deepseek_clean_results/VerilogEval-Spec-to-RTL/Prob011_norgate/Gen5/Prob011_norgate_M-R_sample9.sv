module TopModule (
    input a,
    input b,
    output reg out
);
    always @(a or b) begin
        out = ~(a | b);  // NOR operation implemented in procedural block
    end
endmodule