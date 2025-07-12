module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    reg [0:0] lut [3:0];

    initial begin
        // Index: x y => value
        // 00 => 1
        // 01 => 0
        // 10 => 0
        // 11 => 1
        lut[0] = 1'b1; // x=0, y=0
        lut[1] = 1'b0; // x=0, y=1
        lut[2] = 1'b0; // x=1, y=0
        lut[3] = 1'b1; // x=1, y=1
    end

    assign z = lut[{x,y}];
endmodule