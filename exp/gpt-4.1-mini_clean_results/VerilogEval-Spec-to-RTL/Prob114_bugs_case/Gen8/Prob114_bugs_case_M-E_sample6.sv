module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // One-hot signals for each recognized scancode
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

    wire any_key = key_0 | key_1 | key_2 | key_3 | key_4 | key_5 | key_6 | key_7 | key_8 | key_9;

    always @(*) begin
        valid = any_key;
        // Priority encoder style assignment:
        // In this scenario keys are unique and non-overlapping,
        // so the encoding order does not affect correctness.
        if (key_0)       out = 4'd0;
        else if (key_1)  out = 4'd1;
        else if (key_2)  out = 4'd2;
        else if (key_3)  out = 4'd3;
        else if (key_4)  out = 4'd4;
        else if (key_5)  out = 4'd5;
        else if (key_6)  out = 4'd6;
        else if (key_7)  out = 4'd7;
        else if (key_8)  out = 4'd8;
        else if (key_9)  out = 4'd9;
        else             out = 4'd0;
    end

endmodule