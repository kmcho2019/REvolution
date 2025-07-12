module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);
    always @(*) begin
        // Use shift operations instead of multiplication for optimization
        // sel*4 = sel<<2
        // (sel[7:4]*64) = (sel[7:4]<<6)
        out = in[(sel[7:4] << 6) + (sel[3:0] << 2) +: 4];
    end
endmodule