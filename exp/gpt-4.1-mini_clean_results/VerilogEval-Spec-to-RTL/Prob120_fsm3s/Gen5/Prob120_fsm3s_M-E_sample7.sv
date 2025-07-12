module TopModule (
    input       clk,
    input       reset,
    input       in,
    output reg  out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default next_state to zero for safety
        next_state = 4'b0000;
        out = 1'b0;

        case (1'b1) // one-hot encoding selector
            state[0]: begin // State A
                next_state = in ? B : A;
                out = 1'b0;
            end
            state[1]: begin // State B
                next_state = in ? B : C;
                out = 1'b0;
            end
            state[2]: begin // State C
                next_state = in ? D : A;
                out = 1'b0;
            end
            state[3]: begin // State D
                next_state = in ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;  // Recover to reset state on invalid
                out = 1'b0;
            end
        endcase
    end

endmodule