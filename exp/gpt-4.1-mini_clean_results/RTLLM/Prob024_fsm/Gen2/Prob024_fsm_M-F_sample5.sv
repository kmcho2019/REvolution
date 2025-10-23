module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// State encoding (binary)
localparam S0 = 3'd0; // initial state, no match yet
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched '10'
localparam S3 = 3'd3; // matched '100'
localparam S4 = 3'd4; // matched '1001'

reg [2:0] state, next_state;
reg       match_next;

always @(*) begin
    // Default assignments to hold state and clear output
    next_state = state;
    match_next = 1'b0;

    case (state)
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
                next_state = S1; // stay if input still 1 (repeat possible)
        end

        S2: begin
            if (~IN)
                next_state = S3;
            else
                next_state = S1; // restart pattern from '1'
        end

        S3: begin
            if (IN)
                next_state = S4;
            else
                next_state = S0; // no match, back to start
        end

        S4: begin
            if (IN) begin
                next_state = S1; // loop detection for overlapping sequences
                match_next = 1'b1; // sequence "10011" matched at last '1'
            end else begin
                next_state = S2;
                // match_next = 0;
            end
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
        MATCH <= match_next; // registered Mealy output aligned with state update
    end
end

endmodule