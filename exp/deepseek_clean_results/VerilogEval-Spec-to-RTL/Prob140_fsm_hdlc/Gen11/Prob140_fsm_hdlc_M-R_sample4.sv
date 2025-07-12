module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot encoded states
    reg [6:0] state;
    localparam S0 = 7'b0000001;  // Initial state (0 consecutive 1s)
    localparam S1 = 7'b0000010;  // 1 consecutive 1
    localparam S2 = 7'b0000100;  // 2 consecutive 1s
    localparam S3 = 7'b0001000;  // 3 consecutive 1s
    localparam S4 = 7'b0010000;  // 4 consecutive 1s
    localparam S5 = 7'b0100000;  // 5 consecutive 1s
    localparam S6 = 7'b1000000;  // 6+ consecutive 1s

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (1'b1)
                state[S0]: state <= in ? S1 : S0;
                state[S1]: state <= in ? S2 : S0;
                state[S2]: state <= in ? S3 : S0;
                state[S3]: state <= in ? S4 : S0;
                state[S4]: state <= in ? S5 : S0;
                state[S5]: state <= in ? S6 : S0;
                state[S6]: state <= in ? S6 : S0;
                default:   state <= S0;
            endcase
        end
    end

    // Output registers (delayed by one cycle)
    reg disc_r, flag_r, err_r;
    always @(posedge clk) begin
        if (reset) begin
            disc_r <= 0;
            flag_r <= 0;
            err_r <= 0;
        end else begin
            disc_r <= (state == S5) && !in;
            flag_r <= (state == S6) && !in;
            err_r <= (state == S6) && in;
        end
    end

    // Continuous output assignments
    assign disc = disc_r;
    assign flag = flag_r;
    assign err = err_r;

endmodule