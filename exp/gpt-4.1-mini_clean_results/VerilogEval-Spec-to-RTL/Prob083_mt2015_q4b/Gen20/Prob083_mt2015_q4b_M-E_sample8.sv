module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

localparam [3:0] LUT = 4'b1001;

assign z = LUT[{x,y}];

endmodule