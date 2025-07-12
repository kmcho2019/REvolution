module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [1:0] level1_sel;
wire [1:0] level2_sel;
wire level3_sel;

// Level 1: Split into upper and lower halves
assign level1_sel[0] = |in[3:0];  // Lower half has priority
assign level1_sel[1] = |in[7:4] & ~level1_sel[0];

// Level 2: Split halves into quarters
assign level2_sel[0] = level1_sel[0] ? |in[1:0] : |in[5:4];
assign level2_sel[1] = level1_sel[0] ? (|in[3:2] & ~level2_sel[0]) 
                                    : (|in[7:6] & ~level2_sel[0]);

// Level 3: Final bit selection
assign level3_sel = level1_sel[0] ? 
                   (level2_sel[0] ? in[0] : in[2]) : 
                   (level2_sel[0] ? in[4] : in[6]);

always @(*) begin
    if (|in) begin
        case ({level1_sel, level2_sel, level3_sel})
            5'b10000: pos = 3'd0;  // Bit 0
            5'b10001: pos = 3'd1;  // Bit 1
            5'b10100: pos = 3'd2;  // Bit 2
            5'b10101: pos = 3'd3;  // Bit 3
            5'b01000: pos = 3'd4;  // Bit 4
            5'b01001: pos = 3'd5;  // Bit 5
            5'b01100: pos = 3'd6;  // Bit 6
            5'b01101: pos = 3'd7;  // Bit 7
            default: pos = 3'd0;   // Shouldn't occur
        endcase
    end else begin
        pos = 3'd0;
    end
end

endmodule