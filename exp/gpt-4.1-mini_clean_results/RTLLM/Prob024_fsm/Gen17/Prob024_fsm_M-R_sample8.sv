module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (3 bits)
    typedef enum logic [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4  // matched '1001'
    } state_t;

    state_t state, next_state;

    // Combinational logic for next state and output
    always @* begin
        // Default assignments
        next_state = S0;
        MATCH = 1'b0;

        case(state)
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
                    next_state = S1;
                    MATCH = 1'b1;
                end else begin
                    next_state = S2;
                    MATCH = 1'b0;
                end
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state update and output reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is assigned combinationally above, but registered here
            // to align output with clock edge
        end
    end

endmodule