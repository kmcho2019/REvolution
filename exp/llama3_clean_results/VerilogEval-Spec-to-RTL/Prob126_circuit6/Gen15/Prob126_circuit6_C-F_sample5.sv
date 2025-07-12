module ROM(
    input  [2:0] address,
    output [15:0] data
);

reg [15:0] memory [7:0];

initial begin
    memory[0] = 16'h1232;
    memory[1] = 16'haee0;
    memory[2] = 16'h27d4;
    memory[3] = 16'h5a0e;
    memory[4] = 16'h2066;
    memory[5] = 16'h64ce;
    memory[6] = 16'hc526;
    memory[7] = 16'h2f19;
end

assign data = memory[address];

endmodule

module TopModule(
    input  [2:0] a,
    output [15:0] q
);

ROM rom_module(
    .address(a),
    .data(q)
);

endmodule