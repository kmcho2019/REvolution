module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    reg [6:0] state;
    localparam S0 = 7'b0000001;
    localparam S1 = 7'b0000010;
    localparam S2 = 7'b0000100;
    localparam S3 = 7'b0001000;
    localparam S4 = 7'b0010000;
    localparam S5 = 7'b0100000;
    localparam S6 = 7'b1000000;

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
                state[S5]: state <= in ? S6 : (disc <= 1, S0);
                state[S6]: begin
                    if (in) begin
                        err <= 1;
                        state <= S6;
                    end else begin
                        flag <= 1;
                        state <= S0;
                    end
                end
                default: state <= S0;
            endcase

            // Clear outputs when not being set
            if (!(state[S5] && !in)) disc <= 0;
            if (!(state[S6] && !in)) flag <= 0;
            if (!(state[S6] && in)) err <= 0;
        end
    end

endmodule