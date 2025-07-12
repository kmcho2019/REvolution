module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

    // Define constant LUT values as localparams split into high and low bytes
    localparam [7:0] LUT_HIGH [0:7] = {
        8'h12, // 0x1232 -> 0x12
        8'hae, // 0xaee0 -> 0xae
        8'h27, // 0x27d4 -> 0x27
        8'h5a, // 0x5a0e -> 0x5a
        8'h20, // 0x2066 -> 0x20
        8'h64, // 0x64ce -> 0x64
        8'hc5, // 0xc526 -> 0xc5
        8'h2f  // 0x2f19 -> 0x2f
    };

    localparam [7:0] LUT_LOW [0:7] = {
        8'h32, // 0x1232 -> 0x32
        8'he0, // 0xaee0 -> 0xe0
        8'hd4, // 0x27d4 -> 0xd4
        8'h0e, // 0x5a0e -> 0x0e
        8'h66, // 0x2066 -> 0x66
        8'hce, // 0x64ce -> 0xce
        8'h26, // 0xc526 -> 0x26
        8'h19  // 0x2f19 -> 0x19
    };

    // Combinational block using case for synthesis-friendly mux
    always @(*) begin
        case (a)
            3'd0: q = {LUT_HIGH[0], LUT_LOW[0]};
            3'd1: q = {LUT_HIGH[1], LUT_LOW[1]};
            3'd2: q = {LUT_HIGH[2], LUT_LOW[2]};
            3'd3: q = {LUT_HIGH[3], LUT_LOW[3]};
            3'd4: q = {LUT_HIGH[4], LUT_LOW[4]};
            3'd5: q = {LUT_HIGH[5], LUT_LOW[5]};
            3'd6: q = {LUT_HIGH[6], LUT_LOW[6]};
            3'd7: q = {LUT_HIGH[7], LUT_LOW[7]};
            default: q = 16'h0000;
        endcase
    end

endmodule