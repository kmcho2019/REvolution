module TopModule(
    input [3:0] x,
    output f
);
    // Row bits: {x[3], x[0]}
    // Column bits: {x[1], x[2]}
    // Address formed as: addr = {x[3], x[0], x[1], x[2]}
    wire [3:0] addr = {x[3], x[0], x[1], x[2]};

    // LUT for f, indexed by addr
    // 1 = output 1, 0 = output 0; don't-cares filled with 0
    // LUT binary: bit0 = addr 0, ..., bit15 = addr 15
    // From original mapping:
    // addr : f
    // 0 (0000): d=0
    // 1 (0001): 0
    // 2 (0010): d=0
    // 3 (0011): d=0
    // 4 (0100): 0
    // 5 (0101): d=0
    // 6 (0110): 0
    // 7 (0111): 1
    // 8 (1000): 1
    // 9 (1001): 1
    // 10(1010):0
    // 11(1011):d=0
    // 12(1100):1
    // 13(1101):1
    // 14(1110):0
    // 15(1111):0
    localparam [15:0] LUT = 16'b0000100111100010;

    assign f = LUT[addr];
endmodule