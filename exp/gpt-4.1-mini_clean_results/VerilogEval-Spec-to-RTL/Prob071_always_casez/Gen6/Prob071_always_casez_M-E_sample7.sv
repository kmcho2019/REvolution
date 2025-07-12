module TopModule (
    input  [7:0] in,
    output reg [2:0] pos
);

    wire nibble0_set = |in[3:0]; // Any bit set in lower nibble
    wire nibble1_set = |in[7:4]; // Any bit set in upper nibble

    wire [1:0] low_pos;
    wire [1:0] high_pos;

    // Find position of first set bit in nibble0 (bits 0 to 3)
    assign low_pos = (in[0] ? 2'd0 :
                      in[1] ? 2'd1 :
                      in[2] ? 2'd2 :
                      in[3] ? 2'd3 : 2'd0);

    // Find position of first set bit in nibble1 (bits 4 to 7)
    assign high_pos = (in[4] ? 2'd0 :
                       in[5] ? 2'd1 :
                       in[6] ? 2'd2 :
                       in[7] ? 2'd3 : 2'd0);

    always @(*) begin
        if (nibble0_set)
            pos = low_pos;        // Position in lower nibble
        else if (nibble1_set)
            pos = high_pos + 3'd4; // Position offset by 4 for upper nibble
        else
            pos = 3'd0;           // No bits set, output zero
    end

endmodule