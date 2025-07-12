module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    reg [3:0] lut [0:255]; // lookup table with 256 entries

    initial begin
        // initialize the lookup table
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

    assign valid = (code == 8'h45) || (code == 8'h16) || (code == 8'h1e) || (code == 8'h26) || 
                   (code == 8'h25) || (code == 8'h2e) || (code == 8'h36) || (code == 8'h3d) || 
                   (code == 8'h3e) || (code == 8'h46);

    assign out = (valid)? lut[code] : 4'd0;

endmodule