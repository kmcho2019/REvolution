module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

wire is0 = (code == 8'h45);
wire is1 = (code == 8'h16);
wire is2 = (code == 8'h1e);
wire is3 = (code == 8'h26);
wire is4 = (code == 8'h25);
wire is5 = (code == 8'h2e);
wire is6 = (code == 8'h36);
wire is7 = (code == 8'h3d);
wire is8 = (code == 8'h3e);
wire is9 = (code == 8'h46);

always @(*) begin
    valid = is0 | is1 | is2 | is3 | is4 | is5 | is6 | is7 | is8 | is9;
    
    // Priority encode output based on which is detected; since inputs are exclusive, no conflicts
    if      (is0) out = 4'd0;
    else if (is1) out = 4'd1;
    else if (is2) out = 4'd2;
    else if (is3) out = 4'd3;
    else if (is4) out = 4'd4;
    else if (is5) out = 4'd5;
    else if (is6) out = 4'd6;
    else if (is7) out = 4'd7;
    else if (is8) out = 4'd8;
    else if (is9) out = 4'd9;
    else          out = 4'd0;
end

endmodule