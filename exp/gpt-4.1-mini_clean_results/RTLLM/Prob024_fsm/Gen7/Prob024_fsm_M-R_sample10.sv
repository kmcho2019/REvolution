module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (3-bit binary)
    localparam [2:0]
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5;  // matched '10011' (final)

    reg [2:0] state, next_state;
    reg match_comb; // combinational match signal (Mealy output)

    // Combinational logic for next state and Mealy MATCH output
    always @(*) begin
        case (state)
            S0: begin
                next_state = IN ? S1 : S0;
                match_comb = 1'b0;
            end
            S1: begin
                next_state = IN ? S1 : S2;
                match_comb = 1'b0;
            end
            S2: begin
                next_state = IN ? S1 : S3;
                match_comb = 1'b0;
            end
            S3: begin
                next_state = IN ? S4 : S0;
                match_comb = 1'b0;
            end
            S4: begin
                next_state = IN ? S5 : S2;
                match_comb = IN ? 1'b1 : 1'b0; // MATCH asserted on IN=1 here (completing "10011")
            end
            S5: begin
                // After recognizing, allow for overlapping detection by moving to appropriate next state
                next_state = IN ? S1 : S2;
                match_comb = 1'b0;
            end
            default: begin
                next_state = S0;
                match_comb = 1'b0;
            end
        endcase
    end

    // Sequential logic for state updates and registered MATCH output
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= match_comb;
        end
    end

endmodule