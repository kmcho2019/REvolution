module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] scancode_out [9:0];
    reg [7:0] scancode [9:0];

    initial begin
        scancode[0] = 8'h45; scancode_out[0] = 4'd0;
        scancode[1] = 8'h16; scancode_out[1] = 4'd1;
        scancode[2] = 8'h1e; scancode_out[2] = 4'd2;
        scancode[3] = 8'h26; scancode_out[3] = 4'd3;
        scancode[4] = 8'h25; scancode_out[4] = 4'd4;
        scancode[5] = 8'h2e; scancode_out[5] = 4'd5;
        scancode[6] = 8'h36; scancode_out[6] = 4'd6;
        scancode[7] = 8'h3d; scancode_out[7] = 4'd7;
        scancode[8] = 8'h3e; scancode_out[8] = 4'd8;
        scancode[9] = 8'h46; scancode_out[9] = 4'd9;
    end

    always @(*) begin
        out = 4'd0;
        valid = 1'b0;
        for (int i = 0; i < 10; i++) begin
            if (code == scancode[i]) begin
                out = scancode_out[i];
                valid = 1'b1;
            end
        end
    end

endmodule