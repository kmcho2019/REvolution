module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot encoding for states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case (1'b1) // synthesis parallel_case full_case
            state[0]: begin // State A
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            state[1]: begin // State B
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            state[2]: begin // State C
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            state[3]: begin // State D
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: next_state = A; // Default safe state (should never happen)
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is 1 when in state D (state[3] is high), else 0
    assign out = state[3];

endmodule