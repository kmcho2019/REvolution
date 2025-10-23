module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

always @(in or sel) begin
    out = in[(sel * 4) +: 4]; //+: is used to specify the width of the slice
end

endmodule