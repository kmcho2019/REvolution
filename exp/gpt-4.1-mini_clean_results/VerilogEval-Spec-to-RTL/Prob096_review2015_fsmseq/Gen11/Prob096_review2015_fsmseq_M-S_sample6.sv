module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    typedef enum reg [1:0] {
        S0 = 2'd0, // no match
        S1 = 2'd1, // matched '1'
        S2 = 2'd2, // matched '11'
        S3 = 2'd3  // matched '110'
    } state_t;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        if (start_shifting) begin
            // Remain in detected state once triggered
            next_state = S3;
        end else begin
            case(state)
                S0: next_state = data ? S1 : S0;
                S1: next_state = data ? S2 : S0;
                S2: next_state = data ? S2 : S3;
                S3: next_state = data ? S1 : S0; // After partial match, restart accordingly
                default: next_state = S0;
            endcase
        end
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (state == S3 && data == 1'b1)
                start_shifting <= 1'b1; // sequence 1101 matched
        end
    end

endmodule