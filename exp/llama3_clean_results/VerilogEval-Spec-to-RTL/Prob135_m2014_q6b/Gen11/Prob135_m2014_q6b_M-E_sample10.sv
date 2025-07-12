module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    reg [2:0] currentState;
    reg [2:0] nextState;
    reg lut_y1 [0:5][0:1];

    initial begin
        // Initialize the LUT
        lut_y1[0][0] = 0; // State A, w = 0
        lut_y1[0][1] = 0; // State A, w = 1
        lut_y1[1][0] = 1; // State B, w = 0
        lut_y1[1][1] = 1; // State B, w = 1
        lut_y1[2][0] = 1; // State C, w = 0
        lut_y1[2][1] = 1; // State C, w = 1
        lut_y1[3][0] = 0; // State D, w = 0
        lut_y1[3][1] = 0; // State D, w = 1
        lut_y1[4][0] = 1; // State E, w = 0
        lut_y1[4][1] = 1; // State E, w = 1
        lut_y1[5][0] = 1; // State F, w = 0
        lut_y1[5][1] = 1; // State F, w = 1
    end

    always @(y, w) begin
        // Use the LUT to determine the next state's y[1] bit
        Y1 = lut_y1[y][w];
    end

endmodule