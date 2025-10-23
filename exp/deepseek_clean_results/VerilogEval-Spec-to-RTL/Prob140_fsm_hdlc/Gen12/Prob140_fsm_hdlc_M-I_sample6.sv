module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot state encoding
    parameter [7:0] S0 = 8'b00000001;
    parameter [7:0] S1 = 8'b00000010;
    parameter [7:0] S2 = 8'b00000100;
    parameter [7:0] S3 = 8'b00001000;
    parameter [7:0] S4 = 8'b00010000;
    parameter [7:0] S5 = 8'b00100000;
    parameter [7:0] S6 = 8'b01000000;
    parameter [7:0] S7 = 8'b10000000;

    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // State transitions
            case (1'b1)
                state[S0]: state <= in ? S1 : S0;
                state[S1]: state <= in ? S2 : S0;
                state[S2]: state <= in ? S3 : S0;
                state[S3]: state <= in ? S4 : S0;
                state[S4]: state <= in ? S5 : S0;
                state[S5]: state <= in ? S6 : S0;
                state[S6]: state <= in ? S7 : S0;
                state[S7]: state <= in ? S7 : S0;
                default: state <= S0;
            endcase

            // Output generation (registered)
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= (state == S6 || state == S7) && in;
        end
    end

endmodule