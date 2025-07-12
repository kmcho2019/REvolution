module TopModule(
    input [99:0] a,  // input a is 100 bits wide
    input [99:0] b,  // input b is 100 bits wide
    input sel,
    output [99:0] out  // output out is 100 bits wide
);

always @(a, b, sel) begin
    if (sel == 1'b0) begin
        out = a;
    end else begin
        out = b;
    end
end

endmodule