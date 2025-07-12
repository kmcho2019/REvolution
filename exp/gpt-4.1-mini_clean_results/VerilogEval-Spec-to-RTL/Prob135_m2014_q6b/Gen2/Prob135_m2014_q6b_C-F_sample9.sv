module TopModule(
    input  wire [2:0] y,
    input  wire       w,
    output reg        Y1
);

    always @(*) begin
        // Decode states B, C, E, F from current state y
        wire y2 = y[2];
        wire y1 = y[1];
        wire y0 = y[0];

        wire B = (~y2) & (~y1) & y0;
        wire C = (~y2) & y1 & (~y0);
        wire E = y2 & (~y1) & (~y0);
        wire F = y2 & (~y1) & y0;

        // next_y1 = B | (C & w) | (E & w) | F
        Y1 = B | (C & w) | (E & w) | F;
    end

endmodule