module TopModule(
    input  [7:0] in,
    output [7:0] out
);

// Define a Barrel Shifter module with a fixed shift amount
module BarrelShifter(
    input  [7:0] data_in,
    output [7:0] data_out
);

    // Shift the input data by 7 bits (reverse the bit ordering)
    assign data_out[0] = data_in[7];
    assign data_out[1] = data_in[6];
    assign data_out[2] = data_in[5];
    assign data_out[3] = data_in[4];
    assign data_out[4] = data_in[3];
    assign data_out[5] = data_in[2];
    assign data_out[6] = data_in[1];
    assign data_out[7] = data_in[0];

endmodule

// Instantiate the Barrel Shifter module
BarrelShifter barrel_shifter(
    .data_in(in),
    .data_out(out)
);

endmodule