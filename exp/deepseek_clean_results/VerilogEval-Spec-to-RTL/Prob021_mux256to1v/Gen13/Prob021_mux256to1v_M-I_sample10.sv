module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16 16-to-1 muxes
    wire [3:0] first_level [0:15];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level_muxes
            assign first_level[i] = in[(i*64) + (sel[3:0]*4) +: 4];
        end
    endgenerate

    // Second level: 4 4-to-1 muxes
    wire [3:0] second_level [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : second_level_muxes
            assign second_level[i] = (sel[5:4] == 2'd0) ? first_level[i*4 + 0] :
                                   (sel[5:4] == 2'd1) ? first_level[i*4 + 1] :
                                   (sel[5:4] == 2'd2) ? first_level[i*4 + 2] :
                                   first_level[i*4 + 3];
        end
    endgenerate

    // Third level: Final 4-to-1 mux with one-hot encoding
    wire [3:0] sel7_6_onehot = (1 << sel[7:6]);
    assign out = ({4{sel7_6_onehot[0]}} & second_level[0]) |
                ({4{sel7_6_onehot[1]}} & second_level[1]) |
                ({4{sel7_6_onehot[2]}} & second_level[2]) |
                ({4{sel7_6_onehot[3]}} & second_level[3]);

endmodule