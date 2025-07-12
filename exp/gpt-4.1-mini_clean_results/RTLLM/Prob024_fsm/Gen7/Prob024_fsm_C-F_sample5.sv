module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: track how many bits matched in "10011"
    localparam [2:0]
        S0 = 3'd0,  // no bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Combinational next-state logic based on current state and input,
    // incorporating overlap handling from both examples.
    always @(*) begin
        case (state)
            S0: begin
                if (IN == 1'b1) next_state = S1; else next_state = S0;
            end
            S1: begin
                if (IN == 1'b0) next_state = S2; else next_state = S1;
            end
            S2: begin
                if (IN == 1'b0) next_state = S3; else next_state = S1;
            end
            S3: begin
                if (IN == 1'b1) next_state = S4; else next_state = S0;
            end
            S4: begin
                if (IN == 1'b1) next_state = S1; // detected "10011", input '1' can start new pattern
                else /*IN == 0*/ next_state = S2; // overlap: treat '0' as second bit of new pattern
            end
            default: next_state = S0;
        endcase
    end

    // Sequential state register update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH = 1 when FSM is in S4 and input IN=1 (sequence "10011" detected)
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule