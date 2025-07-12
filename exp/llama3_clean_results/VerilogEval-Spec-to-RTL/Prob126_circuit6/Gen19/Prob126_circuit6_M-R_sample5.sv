module ROM(
    input  [2:0] address,
    output [15:0] data
);

// Define a localparam array to store the output values
localparam [15:0] output_values [8] = {
    16'h1232, // address 0
    16'haee0, // address 1
    16'h27d4, // address 2
    16'h5a0e, // address 3
    16'h2066, // address 4
    16'h64ce, // address 5
    16'hc526, // address 6
    16'h2f19  // address 7
};

// Use a case statement to assign the output value
always_comb begin
    case (address)
        3'b000: data = output_values[0];
        3'b001: data = output_values[1];
        3'b010: data = output_values[2];
        3'b011: data = output_values[3];
        3'b100: data = output_values[4];
        3'b101: data = output_values[5];
        3'b110: data = output_values[6];
        3'b111: data = output_values[7];
        default: data = 16'h0000; // Default case
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