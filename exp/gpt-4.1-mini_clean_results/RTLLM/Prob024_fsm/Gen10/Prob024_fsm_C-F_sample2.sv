module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: number of matched bits of sequence "10011"
    // 0: no match yet
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state, next_state;

    // Next-state logic: combinational block with clear case structure
    always @(*) begin
        case (state)
            3'd0: begin
                if (IN == 1'b1)
                    next_state = 3'd1; // matched first '1'
                else
                    next_state = 3'd0; // remain idle
            end

            3'd1: begin
                if (IN == 1'b0)
                    next_state = 3'd2; // matched '10'
                else
                    next_state = 3'd1; // repeated '1', stay in state 1
            end

            3'd2: begin
                if (IN == 1'b0)
                    next_state = 3'd3; // matched '100'
                else
                    next_state = 3'd1; // '1' could start new sequence
            end

            3'd3: begin
                if (IN == 1'b1)
                    next_state = 3'd4; // matched '1001'
                else
                    next_state = 3'd0; // mismatch, reset
            end

            3'd4: begin
                if (IN == 1'b1)
                    next_state = 3'd1; // full sequence matched, restart from '1'
                else
                    next_state = 3'd2; // partial overlap starting from '10'
            end

            default: next_state = 3'd0;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: assert MATCH when last input bit completes sequence (state 4 + IN=1)
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule