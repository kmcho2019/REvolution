module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

    // ROM: predefined 16-bit output values for each input a
    reg [15:0] rom [0:7];

    initial begin
        rom[0] = 16'h1232;
        rom[1] = 16'haee0;
        rom[2] = 16'h27d4;
        rom[3] = 16'h5a0e;
        rom[4] = 16'h2066;
        rom[5] = 16'h64ce;
        rom[6] = 16'hc526;
        rom[7] = 16'h2f19;
    end

    always @(*) begin
        case (a)
            3'd0: q = rom[0];
            3'd1: q = rom[1];
            3'd2: q = rom[2];
            3'd3: q = rom[3];
            3'd4: q = rom[4];
            3'd5: q = rom[5];
            3'd6: q = rom[6];
            3'd7: q = rom[7];
            default: q = 16'h0000;
        endcase
    end

endmodule