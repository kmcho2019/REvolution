module TopModule (
    input  [7:0] code,
    output [3:0] out,
    output       valid
);

// Define a lookup table for scancodes
reg [3:0] lut [256];
integer i;

// Initialize the lookup table
initial begin
    for (i = 0; i < 256; i++) begin
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

// Use assign for combinational logic
assign out = (code == 8'h45 || code == 8'h16 || code == 8'h1e || code == 8'h26 || code == 8'h25 || code == 8'h2e || code == 8'h36 || code == 8'h3d || code == 8'h3e || code == 8'h46) ? lut[code] : 4'd0;
assign valid = (code == 8'h45 || code == 8'h16 || code == 8'h1e || code == 8'h26 || code == 8'h25 || code == 8'h2e || code == 8'h36 || code == 8'h3d || code == 8'h3e || code == 8'h46);

endmodule