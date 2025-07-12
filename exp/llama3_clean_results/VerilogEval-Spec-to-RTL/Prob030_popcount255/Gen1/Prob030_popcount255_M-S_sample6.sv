module TopModule(
    input  [255:0] in,
    output reg [7:0] out
);

always @(*) begin
    out = 8'd0;
    for (int i = 0; i < 256; i = i + 1) begin
        if (in[i]) out = out + 1;
    end
    if (out > 255) out = 8'd255;
end

endmodule