module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    parameter [7:0] S0 = 8'b00000001;  // Initial state (0)
    parameter [7:0] S1 = 8'b00000010;  // 1
    parameter [7:0] S2 = 8'b00000100;  // 11
    parameter [7:0] S3 = 8'b00001000;  // 111
    parameter [7:0] S4 = 8'b00010000;  // 1111
    parameter [7:0] S5 = 8'b00100000;  // 11111
    parameter [7:0] S6 = 8'b01000000;  // 111111
    parameter [7:0] SE = 8'b10000000;  // Error state (1111111+)

    reg [7:0] state, next_state;
    reg disc_reg, flag_reg, err_reg;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? SE : S0;
            SE: next_state = in ? SE : S0;
            default: next_state = S0;
        endcase
    end

    // Output generation (combinational)
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err = (state == SE) || ((state == S6) && in);

endmodule