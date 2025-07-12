module mux16to1_4bit (
    input  wire [15:0][3:0] data, // 16 inputs, each 4 bits
    input  wire [3:0]       sel,
    output reg  [3:0]       out
);
    always @(*) begin
        case (sel)
            4'd0:  out = data[0];
            4'd1:  out = data[1];
            4'd2:  out = data[2];
            4'd3:  out = data[3];
            4'd4:  out = data[4];
            4'd5:  out = data[5];
            4'd6:  out = data[6];
            4'd7:  out = data[7];
            4'd8:  out = data[8];
            4'd9:  out = data[9];
            4'd10: out = data[10];
            4'd11: out = data[11];
            4'd12: out = data[12];
            4'd13: out = data[13];
            4'd14: out = data[14];
            4'd15: out = data[15];
            default: out = 4'b0;
        endcase
    end
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Split input into 16 groups of 16 elements (each 4 bits)
    // Each group is muxed by sel[3:0] into one 4-bit intermediate output
    wire [15:0][3:0] group_outputs;

    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : groups
            wire [15:0][3:0] group_data;
            for (j = 0; j < 16; j = j + 1) begin : elems
                assign group_data[j] = in[4*(i*16 + j) +: 4];
            end
            mux16to1_4bit u_mux16 (
                .data(group_data),
                .sel(sel[3:0]),
                .out(group_outputs[i])
            );
        end
    endgenerate

    // Final mux: select one of the 16 intermediate results using sel[7:4]
    mux16to1_4bit u_final_mux (
        .data(group_outputs),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule