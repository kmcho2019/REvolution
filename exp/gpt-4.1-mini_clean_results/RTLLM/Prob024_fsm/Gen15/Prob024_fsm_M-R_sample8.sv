module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary-encoded states representing progress in matching "10011"
    localparam [2:0]
        S0 = 3'd0, // no bits matched
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001', waiting last '1'

    reg [2:0] state, next_state;
    reg match_reg;

    // Combinational logic for next state and MATCH output
    always @(*) begin
        // Default assignments
        next_state = S0;
        match_reg = 1'b0;

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
                    // Sequence matched at this point
                    next_state = S1;
                    match_reg = 1'b1;
                end else begin
                    next_state = S2;
                    match_reg = 1'b0;
                end
            end
            default: begin
                next_state = S0;
                match_reg = 1'b0;
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    assign MATCH = match_reg;

endmodule