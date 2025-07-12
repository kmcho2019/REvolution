module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [6:0] ring_counter;

always @(posedge clk) begin
    if (load) begin
        q <= data;
        ring_counter <= 0;
    end else begin
        case (ena)
            2'b01: begin
                // Rotate right by one bit
                ring_counter <= ring_counter + 1;
            end
            2'b10: begin
                // Rotate left by one bit
                ring_counter <= ring_counter - 1;
            end
            default: begin
                // Do not rotate
                ring_counter <= ring_counter;
            end
        endcase
    end
end

// Use the ring counter to rotate the register
always @(*) begin
    case (ring_counter)
        0: q = data;
        1: q = {data[99], data[98:1]};
        2: q = {data[99:1], data[0]};
        3: q = {data[99:2], data[1:0]};
        4: q = {data[99:3], data[2:0]};
        5: q = {data[99:4], data[3:0]};
        6: q = {data[99:5], data[4:0]};
        7: q = {data[99:6], data[5:0]};
        8: q = {data[99:7], data[6:0]};
        9: q = {data[99:8], data[7:0]};
        10: q = {data[99:9], data[8:0]};
        11: q = {data[99:10], data[9:0]};
        12: q = {data[99:11], data[10:0]};
        13: q = {data[99:12], data[11:0]};
        14: q = {data[99:13], data[12:0]};
        15: q = {data[99:14], data[13:0]};
        16: q = {data[99:15], data[14:0]};
        17: q = {data[99:16], data[15:0]};
        18: q = {data[99:17], data[16:0]};
        19: q = {data[99:18], data[17:0]};
        20: q = {data[99:19], data[18:0]};
        21: q = {data[99:20], data[19:0]};
        22: q = {data[99:21], data[20:0]};
        23: q = {data[99:22], data[21:0]};
        24: q = {data[99:23], data[22:0]};
        25: q = {data[99:24], data[23:0]};
        26: q = {data[99:25], data[24:0]};
        27: q = {data[99:26], data[25:0]};
        28: q = {data[99:27], data[26:0]};
        29: q = {data[99:28], data[27:0]};
        30: q = {data[99:29], data[28:0]};
        31: q = {data[99:30], data[29:0]};
        32: q = {data[99:31], data[30:0]};
        33: q = {data[99:32], data[31:0]};
        34: q = {data[99:33], data[32:0]};
        35: q = {data[99:34], data[33:0]};
        36: q = {data[99:35], data[34:0]};
        37: q = {data[99:36], data[35:0]};
        38: q = {data[99:37], data[36:0]};
        39: q = {data[99:38], data[37:0]};
        40: q = {data[99:39], data[38:0]};
        41: q = {data[99:40], data[39:0]};
        42: q = {data[99:41], data[40:0]};
        43: q = {data[99:42], data[41:0]};
        44: q = {data[99:43], data[42:0]};
        45: q = {data[99:44], data[43:0]};
        46: q = {data[99:45], data[44:0]};
        47: q = {data[99:46], data[45:0]};
        48: q = {data[99:47], data[46:0]};
        49: q = {data[99:48], data[47:0]};
        50: q = {data[99:49], data[48:0]};
        51: q = {data[99:50], data[49:0]};
        52: q = {data[99:51], data[50:0]};
        53: q = {data[99:52], data[51:0]};
        54: q = {data[99:53], data[52:0]};
        55: q = {data[99:54], data[53:0]};
        56: q = {data[99:55], data[54:0]};
        57: q = {data[99:56], data[55:0]};
        58: q = {data[99:57], data[56:0]};
        59: q = {data[99:58], data[57:0]};
        60: q = {data[99:59], data[58:0]};
        61: q = {data[99:60], data[59:0]};
        62: q = {data[99:61], data[60:0]};
        63: q = {data[99:62], data[61:0]};
        64: q = {data[99:63], data[62:0]};
        65: q = {data[99:64], data[63:0]};
        66: q = {data[99:65], data[64:0]};
        67: q = {data[99:66], data[65:0]};
        68: q = {data[99:67], data[66:0]};
        69: q = {data[99:68], data[67:0]};
        70: q = {data[99:69], data[68:0]};
        71: q = {data[99:70], data[69:0]};
        72: q = {data[99:71], data[70:0]};
        73: q = {data[99:72], data[71:0]};
        74: q = {data[99:73], data[72:0]};
        75: q = {data[99:74], data[73:0]};
        76: q = {data[99:75], data[74:0]};
        77: q = {data[99:76], data[75:0]};
        78: q = {data[99:77], data[76:0]};
        79: q = {data[99:78], data[77:0]};
        80: q = {data[99:79], data[78:0]};
        81: q = {data[99:80], data[79:0]};
        82: q = {data[99:81], data[80:0]};
        83: q = {data[99:82], data[81:0]};
        84: q = {data[99:83], data[82:0]};
        85: q = {data[99:84], data[83:0]};
        86: q = {data[99:85], data[84:0]};
        87: q = {data[99:86], data[85:0]};
        88: q = {data[99:87], data[86:0]};
        89: q = {data[99:88], data[87:0]};
        90: q = {data[99:89], data[88:0]};
        91: q = {data[99:90], data[89:0]};
        92: q = {data[99:91], data[90:0]};
        93: q = {data[99:92], data[91:0]};
        94: q = {data[99:93], data[92:0]};
        95: q = {data[99:94], data[93:0]};
        96: q = {data[99:95], data[94:0]};
        97: q = {data[99:96], data[95:0]};
        98: q = {data[99:97], data[96:0]};
        99: q = {data[99:98], data[97:0]};
        default: q = data;
    endcase
end

endmodule