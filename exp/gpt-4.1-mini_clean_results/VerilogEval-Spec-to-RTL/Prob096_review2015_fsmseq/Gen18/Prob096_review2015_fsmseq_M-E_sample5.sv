module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  start_shifting
);

    // State encoding: 2 bits sufficient for Mealy FSM tracking "1101"
    // States represent how many prefix bits matched:
    // S0: no match
    // S1: matched '1'
    // S2: matched "11"
    // S3: matched "110"
    typedef enum logic [1:0] {
        S0 = 2'd0,
        S1 = 2'd1,
        S2 = 2'd2,
        S3 = 2'd3
    } state_t;

    state_t state, next_state;

    // Next state logic (Mealy FSM)
    always @(*) begin
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: next_state = data ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state and start_shifting output update
    // start_shifting latches high on sequence detection (when in S3 and data=1)
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;

            // Output sticky logic: if already set, keep set; else set when sequence found
            if (start_shifting == 1'b0) begin
                // Sequence "1101" found when in S3 and data==1 (Mealy output condition)
                if (state == S3 && data == 1'b1)
                    start_shifting <= 1'b1;
            end
        end
    end

endmodule