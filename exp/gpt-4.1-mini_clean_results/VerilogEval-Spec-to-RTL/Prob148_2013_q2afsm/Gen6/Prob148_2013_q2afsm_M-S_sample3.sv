module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    // state[0] = A, state[1] = B, state[2] = C, state[3] = D
    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // A
        else
            state <= next_state;
    end

    // Next-state logic with priority encoding on requests
    always @(*) begin
        case (1'b1)
            state[0]: begin // A
                if (r[0])
                    next_state = 4'b0010; // B
                else if (r[1])
                    next_state = 4'b0100; // C
                else if (r[2])
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // A
            end
            state[1]: next_state = r[0] ? 4'b0010 : 4'b0001; // B
            state[2]: next_state = r[1] ? 4'b0100 : 4'b0001; // C
            state[3]: next_state = r[2] ? 4'b1000 : 4'b0001; // D
            default: next_state = 4'b0001; // safety fallback to A
        endcase
    end

    // Outputs: grant directly from one-hot states B, C, D
    assign g = {state[3], state[2], state[1]};

endmodule