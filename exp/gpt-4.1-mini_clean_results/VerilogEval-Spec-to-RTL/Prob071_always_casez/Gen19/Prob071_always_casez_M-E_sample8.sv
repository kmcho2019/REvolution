module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);
    wire [7:0] one_hot;

    // Generate one_hot mask: bit i set if in[i] is 1 and all lower bits are 0
    assign one_hot[0] = in[0];
    assign one_hot[1] = in[1] & ~in[0];
    assign one_hot[2] = in[2] & ~|in[1:0];
    assign one_hot[3] = in[3] & ~|in[2:0];
    assign one_hot[4] = in[4] & ~|in[3:0];
    assign one_hot[5] = in[5] & ~|in[4:0];
    assign one_hot[6] = in[6] & ~|in[5:0];
    assign one_hot[7] = in[7] & ~|in[6:0];

    always @(*) begin
        case (one_hot)
            8'b00000001: pos = 3'd0;
            8'b00000010: pos = 3'd1;
            8'b00000100: pos = 3'd2;
            8'b00001000: pos = 3'd3;
            8'b00010000: pos = 3'd4;
            8'b00100000: pos = 3'd5;
            8'b01000000: pos = 3'd6;
            8'b10000000: pos = 3'd7;
            default:     pos = 3'd0; // No bits set, output zero
        endcase
    end

endmodule