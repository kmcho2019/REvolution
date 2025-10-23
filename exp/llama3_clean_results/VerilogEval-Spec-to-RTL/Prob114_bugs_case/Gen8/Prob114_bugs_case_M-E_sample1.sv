module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] lut [255:0];

    initial begin
        for (int i = 0; i < 256; i++) begin
            lut[i] = 4'd0;
        end
        lut[8'h45] = 4'd0;
        lut[8'h16] = 4'd1;
        lut[8'h1e] = 4'd2;
        lut[8'h26] = 4'd3;
        lut[8'h25] = 4'd4;
        lut[8'h2e] = 4'd5;
        lut[8'h36] = 4'd6;
        lut[8'h3d] = 4'd7;
        lut[8'h3e] = 4'd8;
        lut[8'h46] = 4'd9;
    end

    always @(*) begin
        out = lut[code];
        valid = (out != 4'd0) ? 1'b1 : 1'b0;
    end

endmodule