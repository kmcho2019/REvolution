// Define the 2-to-1 multiplexer submodule
module mux2X1(
    input  wire    sel,
    input  wire    a,
    input  wire    b,
    output wire    out
);

    assign out = sel ? b : a;

endmodule

// Define the barrel shifter module
module barrel_shifter(
    input  wire    [7:0]  in,
    input  wire    [2:0]  ctrl,
    output wire    [7:0]  out
);

    // Intermediate signals for each stage
    wire [7:0] shift4, shift2, shift1;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux4(
                .sel(ctrl[2]),
                .a(in[i]),
                .b((i < 4) ? in[i+4] : 1'b0),  // Rotate, fill with 0 if shifting beyond bounds
                .out(shift4[i])
            );
        end
    endgenerate

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux2(
                .sel(ctrl[1]),
                .a(shift4[i]),
                .b((i < 6) ? shift4[i+2] : (i < 2 ? shift4[i-2] : shift4[i])),  // Handle wrap-around
                .out(shift2[i])
            );
        end
    endgenerate

    // Stage 3: Shift by 1 position if ctrl[0] is high
    generate
        for (i = 0; i < 8; i++) begin
            mux2X1 mux1(
                .sel(ctrl[0]),
                .a(shift2[i]),
                .b((i < 7) ? shift2[i+1] : shift2[0]),  // Handle wrap-around
                .out(shift1[i])
            );
        end
    endgenerate

    // Assign the final output
    assign out = shift1;

endmodule