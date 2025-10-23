module TopModule(
    input x,
    input y,
    output z
);

reg [0:0] rom [1:0];
initial begin
    rom[0] = 1'b1; // For x=0, y=0, z=1
    rom[1] = 1'b0; // For x=0, y=1, z=0
    rom[2] = 1'b0; // For x=1, y=0, z=0
    rom[3] = 1'b1; // For x=1, y=1, z=1
end

assign z = rom[{x, y}];

endmodule