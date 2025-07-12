module fsm (
    input IN,
    input CLK,
    input RST,
    output reg MATCH
);

    // One-hot state encoding
    parameter [5:0] 
        IDLE   = 6'b000001,
        S1     = 6'b000010,
        S10    = 6'b000100,
        S100   = 6'b001000,
        S1001  = 6'b010000,
        S10011 = 6'b100000;

    reg [5:0] state, next_state;
    wire match_comb;

    // State register
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= match_comb;
        end
    end

    // Next state logic (combinational)
    assign next_state[0] = (~IN & (state[0] | state[2] | state[3])) | 
                          (~IN & state[5]);
    assign next_state[1] = (IN & (state[0] | state[1] | state[5])) | 
                          (IN & state[4]);
    assign next_state[2] = (~IN & state[1]);
    assign next_state[3] = (~IN & state[2]);
    assign next_state[4] = (IN & state[3]);
    assign next_state[5] = (IN & state[4]);

    // Output logic (registered Mealy style)
    assign match_comb = (state[4] & IN);

endmodule