module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    // The sequence to detect: 1 0 0 1 1
    // Index:                0 1 2 3 4
    localparam SEQ_LEN = 5;
    reg [2:0] matched_len; // number of matched bits so far (0 to 5)

    // Next matched length logic
    // At each input, if IN == expected next bit in sequence, increment matched_len
    // else if IN == first bit of sequence (1), reset matched_len to 1 (start new match)
    // else reset matched_len to 0

    wire expected_bit;
    wire [2:0] next_matched_len;

    // Expected bit at current matched_len index
    // sequence = 1 0 0 1 1
    assign expected_bit = (matched_len == 3'd0) ? 1'b1 :
                          (matched_len == 3'd1) ? 1'b0 :
                          (matched_len == 3'd2) ? 1'b0 :
                          (matched_len == 3'd3) ? 1'b1 :
                          (matched_len == 3'd4) ? 1'b1 :
                          1'b0; // default, won't be used

    // Compute next matched length
    // If matched_len == SEQ_LEN (5), reset logic applies here as well to allow overlapping
    assign next_matched_len = (IN == expected_bit) ? (matched_len + 3'd1) :
                             (IN == 1'b1) ? 3'd1 :
                             3'd0;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            matched_len <= 3'd0;
            MATCH <= 1'b0;
        end else begin
            matched_len <= (next_matched_len > SEQ_LEN) ? 3'd0 : next_matched_len;
            // MATCH asserted when matched_len reaches full sequence length exactly at this input
            MATCH <= (matched_len == (SEQ_LEN - 1)) && (IN == expected_bit);
        end
    end

endmodule