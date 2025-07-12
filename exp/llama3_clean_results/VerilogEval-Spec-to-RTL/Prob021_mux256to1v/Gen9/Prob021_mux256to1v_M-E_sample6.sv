module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Level 1: 16-to-1 multiplexers
wire [3:0] level1_out [15:0];
genvar i;
for (i = 0; i < 16; i++) begin
    assign level1_out[i] = in[(i * 64) +: 4];
end

// Level 2: 4-to-1 multiplexers
wire [3:0] level2_out [3:0];
assign level2_out[0] = (sel[3:2] == 2'b00) ? level1_out[0] :
                       (sel[3:2] == 2'b01) ? level1_out[1] :
                       (sel[3:2] == 2'b10) ? level1_out[2] :
                       level1_out[3];

assign level2_out[1] = (sel[3:2] == 2'b00) ? level1_out[4] :
                       (sel[3:2] == 2'b01) ? level1_out[5] :
                       (sel[3:2] == 2'b10) ? level1_out[6] :
                       level1_out[7];

assign level2_out[2] = (sel[3:2] == 2'b00) ? level1_out[8] :
                       (sel[3:2] == 2'b01) ? level1_out[9] :
                       (sel[3:2] == 2'b10) ? level1_out[10] :
                       level1_out[11];

assign level2_out[3] = (sel[3:2] == 2'b00) ? level1_out[12] :
                       (sel[3:2] == 2'b01) ? level1_out[13] :
                       (sel[3:2] == 2'b10) ? level1_out[14] :
                       level1_out[15];

// Level 3: Final 4-to-1 multiplexer
assign out = (sel[1:0] == 2'b00) ? level2_out[0] :
             (sel[1:0] == 2'b01) ? level2_out[1] :
             (sel[1:0] == 2'b10) ? level2_out[2] :
             level2_out[3];

endmodule