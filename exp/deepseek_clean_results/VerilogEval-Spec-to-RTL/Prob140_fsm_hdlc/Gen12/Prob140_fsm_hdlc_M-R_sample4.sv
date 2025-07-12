module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    parameter S0 = 4'b0001;  // Initial state (0)
    parameter S1 = 4'b0010;  // 1
    parameter S2 = 4'b0100;  // 11
    parameter S3 = 4'b1000;  // 111 or more
    reg [3:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S3 : S0;
            default: next_state = S0;
        endcase
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (state == S2) & ~in;
            flag <= (state == S3) & ~in;
            err <= (state == S3) & in;
        end
    end

endmodule