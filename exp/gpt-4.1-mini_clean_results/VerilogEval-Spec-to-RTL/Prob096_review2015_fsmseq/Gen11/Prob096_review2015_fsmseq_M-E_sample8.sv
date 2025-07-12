module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding for Mealy FSM
    // Fewer states due to output depending on input as well
    typedef enum reg [1:0] {
        S0 = 2'b00, // no match yet
        S1 = 2'b01, // matched '1'
        S2 = 2'b10, // matched '11'
        S3 = 2'b11  // matched '110'
    } state_t;

    state_t state, next_state;
    reg detected; // Latch for detection to keep start_shifting asserted

    // Combinational logic: next state and immediate detection signal
    reg detected_now;
    always @(*) begin
        detected_now = 1'b0;
        case (state)
            S0: next_state = data ? S1 : S0;
            S1: next_state = data ? S2 : S0;
            S2: next_state = data ? S2 : S3;
            S3: begin
                if (data) begin
                    next_state = S1;
                    detected_now = 1'b1; // sequence "1101" detected on this input
                end else
                    next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // Sequential logic: update state and detection latch on clock
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            detected <= 1'b0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            if (detected_now)
                detected <= 1'b1;
            start_shifting <= detected;
        end
    end

endmodule