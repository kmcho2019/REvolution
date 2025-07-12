module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state computation
    wire [2:0] Y;
    assign Y[0] = (~x & (y == 3'b011)) |  // x=0, y=011 → 001
                  (x & (y == 3'b000)) |   // x=1, y=000 → 001
                  (x & (y == 3'b001)) |   // x=1, y=001 → 100 (only bit 0)
                  (x & (y == 3'b010)) |  // x=1, y=010 → 001
                  (x & (y == 3'b011));    // x=1, y=011 → 010 (only bit 0)

    assign Y[1] = (~x & (y == 3'b010)) |  // x=0, y=010 → 010
                  (~x & (y == 3'b100)) |  // x=0, y=100 → 011
                  (x & (y == 3'b011));    // x=1, y=011 → 010

    assign Y[2] = (x & (y == 3'b001)) |   // x=1, y=001 → 100
                  (~x & (y == 3'b100)) |  // x=0, y=100 → 011
                  (x & (y == 3'b100));    // x=1, y=100 → 100

    // Output computation
    assign z = (y == 3'b011) | (y == 3'b100);

    // Y0 is simply Y[0]
    assign Y0 = Y[0];

endmodule