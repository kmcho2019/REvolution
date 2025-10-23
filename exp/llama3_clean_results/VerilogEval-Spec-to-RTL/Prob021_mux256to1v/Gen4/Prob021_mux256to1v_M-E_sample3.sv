module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    reg [255:0] enable;
    reg [1023:0] masked_in;

    always @(*) begin
        enable = 0;
        enable[sel] = 1;
        masked_in = 0;
        for (int i = 0; i < 256; i++) begin
            masked_in[(i * 4) +: 4] = (in[(i * 4) +: 4] & {4{enable[i]}});
        end
        out = 0;
        for (int i = 0; i < 256; i++) begin
            out |= masked_in[(i * 4) +: 4];
        end
    end

endmodule