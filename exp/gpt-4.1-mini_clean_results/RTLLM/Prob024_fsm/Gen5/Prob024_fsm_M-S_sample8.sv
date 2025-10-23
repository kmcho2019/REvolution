module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    localparam S0 = 3'd0;  // no bits matched
    localparam S1 = 3'd1;  // matched '1'
    localparam S2 = 3'd2;  // matched '10'
    localparam S3 = 3'd3;  // matched '100'
    localparam S4 = 3'd4;  // matched '1001'
    // S5 (matched '10011') not needed as output is Mealy type on last '1'

    reg [2:0] state, next_state;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            // Default no match
            MATCH <= 1'b0;
            // Next state logic and output combined
            case (state)
                S0: begin
                    if (IN)
                        next_state = S1;
                    else
                        next_state = S0;
                end
                S1: begin
                    if (IN == 1'b0)
                        next_state = S2;
                    else
                        next_state = S1;
                end
                S2: begin
                    if (IN == 1'b0)
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
                        next_state = S1;
                        MATCH <= 1'b1;  // Sequence matched here (10011)
                    end else
                        next_state = S2;
                end
                default: next_state = S0;
            endcase
            state <= next_state;
        end
    end

endmodule