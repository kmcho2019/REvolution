module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output reg  [3:0]    out
);
    always @(*) begin
        // Calculate starting bit position: sel * 4
        // Since sel is 8-bit, sel*4 fits in 10 bits, enough for indexing 0..1020
        integer base_bit;
        base_bit = sel * 4;
        out = in[base_bit +: 4];
    end
endmodule