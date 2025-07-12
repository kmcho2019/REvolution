module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

    // Define a constant lookup table using localparam
    localparam [15:0] LUT [0:7] = {
        16'h2f19,  // a=7
        16'hc526,  // a=6
        16'h64ce,  // a=5
        16'h2066,  // a=4
        16'h5a0e,  // a=3
        16'h27d4,  // a=2
        16'haee0,  // a=1
        16'h1232   // a=0
    };

    always @(*) begin
        case (a)
            3'd0: q = LUT[0];
            3'd1: q = LUT[1];
            3'd2: q = LUT[2];
            3'd3: q = LUT[3];
            3'd4: q = LUT[4];
            3'd5: q = LUT[5];
            3'd6: q = LUT[6];
            3'd7: q = LUT[7];
            default: q = 16'h0000;  // default case, though 'a' is 3-bit so covered
        endcase
    end

endmodule