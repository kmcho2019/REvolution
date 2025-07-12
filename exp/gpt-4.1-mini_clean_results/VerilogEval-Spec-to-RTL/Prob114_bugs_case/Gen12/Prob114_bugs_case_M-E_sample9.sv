module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    wire [9:0] detected;

    // Generate detection flags for each scancode
    assign detected[0] = (code == 8'h45);
    assign detected[1] = (code == 8'h16);
    assign detected[2] = (code == 8'h1e);
    assign detected[3] = (code == 8'h26);
    assign detected[4] = (code == 8'h25);
    assign detected[5] = (code == 8'h2e);
    assign detected[6] = (code == 8'h36);
    assign detected[7] = (code == 8'h3d);
    assign detected[8] = (code == 8'h3e);
    assign detected[9] = (code == 8'h46);

    // Priority encoding: from 0 to 9
    always @(*) begin
        valid = |detected;
        if (detected[0])      out = 4'd0;
        else if (detected[1]) out = 4'd1;
        else if (detected[2]) out = 4'd2;
        else if (detected[3]) out = 4'd3;
        else if (detected[4]) out = 4'd4;
        else if (detected[5]) out = 4'd5;
        else if (detected[6]) out = 4'd6;
        else if (detected[7]) out = 4'd7;
        else if (detected[8]) out = 4'd8;
        else if (detected[9]) out = 4'd9;
        else                  out = 4'd0;
    end

endmodule