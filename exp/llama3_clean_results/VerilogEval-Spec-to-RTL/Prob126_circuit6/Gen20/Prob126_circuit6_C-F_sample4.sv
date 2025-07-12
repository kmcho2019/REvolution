module ROM(
    input  [2:0] address,
    output [15:0] data
);

// Using the assign statement with conditional operators to generate the output values
assign data = (address == 3'b000) ? 16'h1232 :
               (address == 3'b001) ? 16'haee0 :
               (address == 3'b010) ? 16'h27d4 :
               (address == 3'b011) ? 16'h5a0e :
               (address == 3'b100) ? 16'h2066 :
               (address == 3'b101) ? 16'h64ce :
               (address == 3'b110) ? 16'hc526 :
               (address == 3'b111) ? 16'h2f19 :
               16'h0000; // Default case, though not expected to occur

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