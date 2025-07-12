module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoding of states for "1101" detection:
    // 5 states: S0(no match), S1('1'), S2('11'), S3('110'), S4('1101 detected')
    localparam S0 = 5'b00001,
               S1 = 5'b00010,
               S2 = 5'b00100,
               S3 = 5'b01000,
               S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            S0: next_state = (data) ? S1 : S0;
            S1: next_state = (data) ? S2 : S0;
            S2: next_state = (data) ? S2 : S3; // Stay in S2 on '1' to handle overlapping 1s
            S3: next_state = (data) ? S4 : S0; // '1' completes the sequence
            S4: next_state = S4; // Latch detected state
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update and start_shifting output
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Once detected, latch start_shifting high until reset
            if (start_shifting)
                start_shifting <= 1'b1;
            else if (next_state == S4)
                start_shifting <= 1'b1;
        end
    end

endmodule