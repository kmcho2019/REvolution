module TopModule(
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

// Divide the select signal into two parts: high 4 bits and low 4 bits
// This allows us to use a two-stage multiplexer structure
wire [3:0] sel_high = sel[7:4];
wire [3:0] sel_low = sel[3:0];

// First stage: Select a 16-bit segment from the input vector based on the high 4 bits of the select signal
wire [15:0] segment;
always @(*) begin
    case (sel_high)
        8'd0: segment = in[15:0];
        8'd1: segment = in[31:16];
        8'd2: segment = in[47:32];
        8'd3: segment = in[63:48];
        8'd4: segment = in[79:64];
        8'd5: segment = in[95:80];
        8'd6: segment = in[111:96];
        8'd7: segment = in[127:112];
        8'd8: segment = in[143:128];
        8'd9: segment = in[159:144];
        8'd10: segment = in[175:160];
        8'd11: segment = in[191:176];
        8'd12: segment = in[207:192];
        8'd13: segment = in[223:208];
        8'd14: segment = in[239:224];
        8'd15: segment = in[255:240];
        default: segment = 16'd0;
    endcase
end

// Second stage: Select the final bit from the 16-bit segment based on the low 4 bits of the select signal
assign out = segment[sel_low];

endmodule