module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

always @(*)
begin
    case(sel)
        // For each possible sel value, extract the corresponding 4-bit input from the input vector
        // Since we know sel is 8 bits, we only need to consider 0 to 255
        for (int i = 0; i < 256; i++)
        begin
            i: out = in[(i * 4) +: 4];  // +: 4 means extract 4 bits starting from (i * 4)
        end
        default: out = 4'b0;  // If sel is outside the range 0-255, output 0
    endcase
end

endmodule