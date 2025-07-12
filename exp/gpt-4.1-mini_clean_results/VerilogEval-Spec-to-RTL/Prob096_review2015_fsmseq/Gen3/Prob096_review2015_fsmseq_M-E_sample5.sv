module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding using localparams
    localparam IDLE  = 3'd0; // no match yet
    localparam S1    = 3'd1; // matched '1'
    localparam S11   = 3'd2; // matched '11'
    localparam S110  = 3'd3; // matched '110'
    localparam FOUND = 3'd4; // sequence found, output latched

    reg [2:0] state, next_state;
    reg next_start_shifting;

    // Combinational logic for next state and output (Mealy output depends on input)
    always @* begin
        next_state = state;
        next_start_shifting = start_shifting;

        case (state)
            IDLE: begin
                next_start_shifting = 1'b0;
                if (data)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                next_start_shifting = 1'b0;
                if (data)
                    next_state = S11;
                else
                    next_state = IDLE;
            end

            S11: begin
                next_start_shifting = 1'b0;
                if (data)
                    next_state = S11; // stay on double 1's if input 1
                else
                    next_state = S110;
            end

            S110: begin
                // If input bit is 1, sequence "1101" detected, assert start_shifting immediately
                if (data) begin
                    next_start_shifting = 1'b1;
                    next_state = FOUND;
                end else begin
                    next_start_shifting = 1'b0;
                    next_state = IDLE;
                end
            end

            FOUND: begin
                next_start_shifting = 1'b1;
                next_state = FOUND; // remain here forever until reset
            end

            default: begin
                next_start_shifting = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

    // Sequential block for state and output with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= next_start_shifting;
        end
    end

endmodule