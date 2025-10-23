module TopModule(
    input [99:0] a,  // 100 bits input
    input [99:0] b,  // 100 bits input
    input sel,
    output reg [99:0] out  // 100 bits output
);

always @(*) begin
    out = (sel == 1'b1)? b : a;
end

endmodule