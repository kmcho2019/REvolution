// Define a 2-to-1 multiplexer submodule
module mux2X1(
    input   [7:0]  in0,  // First input
    input   [7:0]  in1,  // Second input
    input           sel, // Select signal
    output  [7:0]  out   // Output
);
    always @(*) begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = 8'b0; // Default to 0
        endcase
    end
endmodule

// Define the barrel shifter module
module barrel_shifter(
    input   [7:0]  in,   // 8-bit input to be shifted
    input   [2:0]  ctrl, // 3-bit control signal
    output  [7:0]  out   // 8-bit shifted output
);
    wire    [7:0]  shift4; // Intermediate result after shift by 4
    wire    [7:0]  shift2; // Intermediate result after shift by 2
    wire    [7:0]  shift1; // Intermediate result after shift by 1

    // Shift by 4 positions
    assign shift4 = {in[3:0], 4'b0000}; // Logical shift left by 4

    // First stage: Select between original input and shifted by 4
    mux2X1 mux_stage4(
        .in0(in),
        .in1(shift4),
        .sel(ctrl[2]),
        .out(shift2)
    );

    // Shift by 2 positions
    assign shift1 = {shift2[5:0], 2'b00}; // Logical shift left by 2

    // Second stage: Select between intermediate result and shifted by 2
    mux2X1 mux_stage2(
        .in0(shift2),
        .in1(shift1),
        .sel(ctrl[1]),
        .out(shift1)
    );

    // Shift by 1 position
    assign shift1 = {shift1[6:0], 1'b0}; // Logical shift left by 1

    // Third stage: Select between intermediate result and shifted by 1
    mux2X1 mux_stage1(
        .in0(shift1),
        .in1({shift1[6:0], 1'b0}),
        .sel(ctrl[0]),
        .out(out)
    );
endmodule