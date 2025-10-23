module TopModule (
    input [254:0] in,
    output [7:0] out
);

    // First level: 255 1-bit adders
    wire [254:0] first_level_out;
    assign first_level_out = in;

    // Second level: 127 2-bit adders
    wire [126:0] second_level_out;
    genvar i;
    generate
        for (i = 0; i < 127; i++) begin
            assign second_level_out[i] = first_level_out[2*i] + first_level_out[2*i+1];
        end
    endgenerate

    // Third level: 63 3-bit adders ( treating previous level output as 2-bit values)
    wire [62:0] third_level_out;
    generate
        for (i = 0; i < 63; i++) begin
            assign third_level_out[i] = second_level_out[2*i] + second_level_out[2*i+1];
        end
    endgenerate

    // Fourth level: 31 4-bit adders (treating previous level output as 3-bit values, 
    // with one carry bit per group)
    wire [30:0] fourth_level_out;
    generate
        for (i = 0; i < 31; i++) begin
            assign fourth_level_out[i] = third_level_out[2*i] + third_level_out[2*i+1];
        end
    endgenerate

    // Fifth level: 15 5-bit adders
    wire [14:0] fifth_level_out;
    generate
        for (i = 0; i < 15; i++) begin
            assign fifth_level_out[i] = fourth_level_out[2*i] + fourth_level_out[2*i+1];
        end
    endgenerate

    // Sixth level: 7 6-bit adders
    wire [6:0] sixth_level_out;
    generate
        for (i = 0; i < 7; i++) begin
            assign sixth_level_out[i] = fifth_level_out[2*i] + fifth_level_out[2*i+1];
        end
    endgenerate

    // Seventh level: 3 7-bit adders
    wire [2:0] seventh_level_out;
    generate
        for (i = 0; i < 3; i++) begin
            assign seventh_level_out[i] = sixth_level_out[2*i] + sixth_level_out[2*i+1];
        end
    endgenerate

    // Eighth level: 1 8-bit adder
    wire [7:0] eighth_level_out;
    assign eighth_level_out[0] = seventh_level_out[0];
    assign eighth_level_out[1] = seventh_level_out[1];
    assign eighth_level_out[2] = seventh_level_out[2];

    assign out = eighth_level_out;

endmodule