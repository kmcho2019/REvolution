module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    wire [15:0] chunk_out;

    // Select one of 16 chunks based on upper 4 bits of sel
    always @(in or sel) begin
        case (sel[7:4])
            8'd0: chunk_out = in[15:0];
            8'd1: chunk_out = in[31:16];
            8'd2: chunk_out = in[47:32];
            8'd3: chunk_out = in[63:48];
            8'd4: chunk_out = in[79:64];
            8'd5: chunk_out = in[95:80];
            8'd6: chunk_out = in[111:96];
            8'd7: chunk_out = in[127:112];
            8'd8: chunk_out = in[143:128];
            8'd9: chunk_out = in[159:144];
            8'd10: chunk_out = in[175:160];
            8'd11: chunk_out = in[191:176];
            8'd12: chunk_out = in[207:192];
            8'd13: chunk_out = in[223:208];
            8'd14: chunk_out = in[239:224];
            8'd15: chunk_out = in[255:240];
            default: chunk_out = 16'd0;
        endcase
    end

    // Select one bit from the chosen chunk based on lower 4 bits of sel
    assign out = chunk_out[sel[3:0]];

endmodule