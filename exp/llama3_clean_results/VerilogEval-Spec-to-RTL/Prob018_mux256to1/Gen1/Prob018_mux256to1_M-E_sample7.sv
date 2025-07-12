module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Level 1: 4-to-1 multiplexers
    wire [63:0] level1_out;
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin
            mux4to1 mux4to1_inst(
               .in({in[i*4+3], in[i*4+2], in[i*4+1], in[i*4]}),
               .sel(sel[1:0]),
               .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 16-to-1 multiplexers
    wire [15:0] level2_out;
    generate
        for (i = 0; i < 16; i++) begin
            mux16to1 mux16to1_inst(
               .in(level1_out[i*4+3:i*4]),
               .sel(sel[3:2]),
               .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: 64-to-1 multiplexers
    wire [3:0] level3_out;
    generate
        for (i = 0; i < 4; i++) begin
            mux64to1 mux64to1_inst(
               .in(level2_out[i*16+15:i*16]),
               .sel(sel[5:4]),
               .out(level3_out[i])
            );
        end
    endgenerate

    // Level 4: Final 4-to-1 multiplexer
    mux4to1 mux4to1_final(
       .in(level3_out),
       .sel(sel[7:6]),
       .out(out)
    );

endmodule

// 4-to-1 multiplexer module
module mux4to1(
    input [3:0] in,
    input [1:0] sel,
    output out
);
    always @(*) begin
        case (sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
        endcase
    end
endmodule

// 16-to-1 multiplexer module
module mux16to1(
    input [15:0] in,
    input [3:0] sel,
    output out
);
    always @(*) begin
        case (sel)
            4'b0000: out = in[0];
            4'b0001: out = in[1];
            4'b0010: out = in[2];
            4'b0011: out = in[3];
            4'b0100: out = in[4];
            4'b0101: out = in[5];
            4'b0110: out = in[6];
            4'b0111: out = in[7];
            4'b1000: out = in[8];
            4'b1001: out = in[9];
            4'b1010: out = in[10];
            4'b1011: out = in[11];
            4'b1100: out = in[12];
            4'b1101: out = in[13];
            4'b1110: out = in[14];
            4'b1111: out = in[15];
        endcase
    end
endmodule

// 64-to-1 multiplexer module
module mux64to1(
    input [63:0] in,
    input [5:0] sel,
    output out
);
    always @(*) begin
        case (sel)
            6'b000000: out = in[0];
            6'b000001: out = in[1];
            6'b000010: out = in[2];
            6'b000011: out = in[3];
            //... (add more cases for all 64 inputs)
            6'b111111: out = in[63];
        endcase
    end
endmodule