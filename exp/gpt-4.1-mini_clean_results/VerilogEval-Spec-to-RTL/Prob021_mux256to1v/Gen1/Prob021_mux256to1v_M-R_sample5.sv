module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);

    integer i;
    always @(*) begin
        case (sel)
            // Generate all cases for sel = 0 to 255
            // Each case assigns a 4-bit slice from 'in' to 'out'
            8'd0:   out = in[3:0];
            8'd1:   out = in[7:4];
            8'd2:   out = in[11:8];
            8'd3:   out = in[15:12];
            8'd4:   out = in[19:16];
            8'd5:   out = in[23:20];
            8'd6:   out = in[27:24];
            8'd7:   out = in[31:28];
            8'd8:   out = in[35:32];
            8'd9:   out = in[39:36];
            8'd10:  out = in[43:40];
            8'd11:  out = in[47:44];
            8'd12:  out = in[51:48];
            8'd13:  out = in[55:52];
            8'd14:  out = in[59:56];
            8'd15:  out = in[63:60];
            8'd16:  out = in[67:64];
            8'd17:  out = in[71:68];
            8'd18:  out = in[75:72];
            8'd19:  out = in[79:76];
            8'd20:  out = in[83:80];
            8'd21:  out = in[87:84];
            8'd22:  out = in[91:88];
            8'd23:  out = in[95:92];
            8'd24:  out = in[99:96];
            8'd25:  out = in[103:100];
            8'd26:  out = in[107:104];
            8'd27:  out = in[111:108];
            8'd28:  out = in[115:112];
            8'd29:  out = in[119:116];
            8'd30:  out = in[123:120];
            8'd31:  out = in[127:124];
            // The pattern continues similarly for all values up to 255
            default: out = 4'b0000;
        endcase
    end

endmodule