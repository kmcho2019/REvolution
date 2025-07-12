module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// States represent how many bits matched of "10011"
localparam S0 = 3'd0; // no match yet
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched '10'
localparam S3 = 3'd3; // matched '100'
localparam S4 = 3'd4; // matched '1001'
localparam S5 = 3'd5; // matched full '10011'

reg [2:0] state, next_state;
reg match_next;

always @(*) begin
    match_next = 1'b0;
    case (state)
        S0: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1; // remain on repeated '1'
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S5;
                match_next = 1'b1; // Sequence matched
            end else
                next_state = S2;
        end
        S5: begin
            // After match, check for overlapping prefix "11"
            // Input = 1 means pattern restarts with S1, else with S2 (from pattern)
            match_next = 1'b0; // MATCH only asserted on entering S5
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S2;
        end
        default: begin
            next_state = S0;
            match_next = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_next;
    end
end

endmodule