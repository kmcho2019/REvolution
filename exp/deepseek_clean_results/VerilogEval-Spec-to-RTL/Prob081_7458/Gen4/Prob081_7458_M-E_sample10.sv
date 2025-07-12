module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // LUT for p1y: OR of two 3-input ANDs
    reg [63:0] p1y_lut;
    initial begin
        for (integer i = 0; i < 64; i = i + 1) begin
            p1y_lut[i] = ((i[5] & i[4] & i[3]) | (i[2] & i[1] & i[0]));
        end
    end

    // LUT for p2y: OR of two 2-input ANDs
    reg [15:0] p2y_lut;
    initial begin
        for (integer i = 0; i < 16; i = i + 1) begin
            p2y_lut[i] = ((i[3] & i[2]) | (i[1] & i[0]);
        end
    end

    assign p1y = p1y_lut[{p1a, p1b, p1c, p1d, p1e, p1f}];
    assign p2y = p2y_lut[{p2a, p2b, p2c, p2d}];

endmodule