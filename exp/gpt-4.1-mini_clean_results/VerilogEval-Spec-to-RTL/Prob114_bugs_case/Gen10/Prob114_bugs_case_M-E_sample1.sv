module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // One-hot detection for each scancode
    wire key_0 = (code == 8'h45);
    wire key_1 = (code == 8'h16);
    wire key_2 = (code == 8'h1e);
    wire key_3 = (code == 8'h26);
    wire key_4 = (code == 8'h25);
    wire key_5 = (code == 8'h2e);
    wire key_6 = (code == 8'h36);
    wire key_7 = (code == 8'h3d);
    wire key_8 = (code == 8'h3e);
    wire key_9 = (code == 8'h46);

    always @(*) begin
        valid = key_0 | key_1 | key_2 | key_3 | key_4 | key_5 | key_6 | key_7 | key_8 | key_9;
        case (1'b1) // priority encoder style on one-hot signals
            key_0: out = 4'd0;
            key_1: out = 4'd1;
            key_2: out = 4'd2;
            key_3: out = 4'd3;
            key_4: out = 4'd4;
            key_5: out = 4'd5;
            key_6: out = 4'd6;
            key_7: out = 4'd7;
            key_8: out = 4'd8;
            key_9: out = 4'd9;
            default: out = 4'd0;
        endcase
    end

endmodule