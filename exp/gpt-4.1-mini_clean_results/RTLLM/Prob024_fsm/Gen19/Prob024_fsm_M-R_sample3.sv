module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4
    } state_t;

    state_t state, next_state;
    logic match_next;

    // Combinational logic for next_state and output (Mealy)
    always_comb begin
        next_state = S0;
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
                    next_state = S1;
            end
            S2: begin
                if (~IN)
                    next_state = S3;
                else
                    next_state = S1;
            end
            S3: begin
                if (IN) begin
                    next_state = S4;
                end else begin
                    next_state = S0;
                end
            end
            S4: begin
                if (IN) begin
                    match_next = 1'b1;  // Mealy output asserted when input is 1 at S4
                    next_state = S1;
                end else begin
                    match_next = 1'b0;
                    next_state = S2;
                end
            end
            default: begin
                next_state = S0;
                match_next = 1'b0;
            end
        endcase
    end

    // Synchronous state update and output register
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            MATCH <= match_next;
        end
    end

endmodule