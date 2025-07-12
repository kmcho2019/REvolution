module ROM(
    input  [2:0] address,
    output [15:0] data
);

// Using a case statement to generate the output values
always @(*) begin
    case (address)
        3'b000: data = 16'h1232;
        3'b001: data = 16'haee0;
        3'b010: data = 16'h27d4;
        3'b011: data = 16'h5a0e;
        3'b100: data = 16'h2066;
        3'b101: data = 16'h64ce;
        3'b110: data = 16'hc526;
        3'b111: data = 16'h2f19;
        default: data = 16'h0000;
    endcase
end

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