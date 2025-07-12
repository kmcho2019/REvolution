module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding using localparams
    localparam S0 = 3'd0;  // Initial state, no matches yet
    localparam S1 = 3'd1;  // Matched '1'
    localparam S2 = 3'd2;  // Matched '10'
    localparam S3 = 3'd3;  // Matched '100'
    localparam S4 = 3'd4;  // Matched '1001'

    reg [2:0] current_state, next_state;
    reg       match_comb;  // combinational match signal

    // Next state and output logic (combinational)
    always @(*) begin
        // Default assignments
        next_state = current_state;
        match_comb = 1'b0;

        case (current_state)
            S0: begin
                if (IN)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                if (~IN)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S2: begin
                if (~IN)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (IN)
                    next_state = S4;
                else
                    next_state = S0;
            end
            S4: begin
                if (IN) begin
                    // Full sequence matched here on input '1' at S4
                    match_comb = 1'b1;
                    // Overlapping detection: last '1' could start new sequence
                    next_state = S1;
                end else begin
                    // On '0', partial sequence matched: "10"
                    next_state = S2;
                end
            end
            default: begin
                next_state = S0;
                match_comb = 1'b0;
            end
        endcase
    end

    // Sequential state and output update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            current_state <= next_state;
            MATCH <= match_comb;
        end
    end

endmodule