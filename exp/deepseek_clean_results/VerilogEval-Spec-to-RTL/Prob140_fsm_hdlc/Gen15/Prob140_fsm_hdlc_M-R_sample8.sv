module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    parameter S0 = 8'b00000001;  // Initial state (0 consecutive 1s)
    parameter S1 = 8'b00000010;  // 1 consecutive 1
    parameter S2 = 8'b00000100;  // 2 consecutive 1s
    parameter S3 = 8'b00001000;  // 3 consecutive 1s
    parameter S4 = 8'b00010000;  // 4 consecutive 1s
    parameter S5 = 8'b00100000;  // 5 consecutive 1s (discard next 0)
    parameter S6 = 8'b01000000;  // 6 consecutive 1s (flag)
    parameter S7 = 8'b10000000;  // 7+ consecutive 1s (error)

    reg [7:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

    // State transition and output generation
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Output conditions
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= (state == S6 && in) || (state == S7);
        end
    end

endmodule