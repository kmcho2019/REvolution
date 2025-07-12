module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    reg [31:0] temp;

    always @(*) begin
        temp = 32'd0;
        for (int i = 0; i < 4; i++) begin
            temp[(i*8)+:8] = in[(3-i)*8 +: 8];
        end
        out = temp;
    end

endmodule