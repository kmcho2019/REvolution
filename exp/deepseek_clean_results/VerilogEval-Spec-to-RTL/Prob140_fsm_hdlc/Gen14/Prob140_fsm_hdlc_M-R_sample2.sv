module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot state encoding
    reg [7:0] state;
    localparam S0 = 8'b00000001;
    localparam S1 = 8'b00000010;
    localparam S2 = 8'b00000100;
    localparam S3 = 8'b00001000;
    localparam S4 = 8'b00010000;
    localparam S5 = 8'b00100000;
    localparam S6 = 8'b01000000;
    localparam S7 = 8'b10000000;

    // Output assignments
    assign disc = (state == S5) & ~in;
    assign flag = (state == S6) & ~in;
    assign err = (state == S7) | ((state == S6) & in);

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[S0]: state <= in ? S1 : S0;
                state[S1]: state <= in ? S2 : S0;
                state[S2]: state <= in ? S3 : S0;
                state[S3]: state <= in ? S4 : S0;
                state[S4]: state <= in ? S5 : S0;
                state[S5]: state <= in ? S6 : S0;
                state[S6]: state <= in ? S7 : S0;
                state[S7]: state <= S7; // Stay in error state
                default: state <= S0;
            endcase
        end
    end

endmodule