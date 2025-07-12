module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // One-hot encoding of states for counts 0 to 7+ consecutive ones
    localparam
        S0 = 8'b0000_0001,
        S1 = 8'b0000_0010,
        S2 = 8'b0000_0100,
        S3 = 8'b0000_1000,
        S4 = 8'b0001_0000,
        S5 = 8'b0010_0000,
        S6 = 8'b0100_0000,
        S7 = 8'b1000_0000; // 7 or more ones (error state)

    reg [7:0] state, next_state;

    // Next state combinational logic using one-hot style
    // Only one bit in next_state will be set
    wire in_ = in;

    always @(*) begin
        case (1'b1)
            state[S0]: next_state = in_ ? S1 : S0;
            state[S1]: next_state = in_ ? S2 : S0;
            state[S2]: next_state = in_ ? S3 : S0;
            state[S3]: next_state = in_ ? S4 : S0;
            state[S4]: next_state = in_ ? S5 : S0;
            state[S5]: next_state = in_ ? S6 : S0;
            state[S6]: next_state = in_ ? S7 : S0;
            state[S7]: next_state = in_ ? S7 : S0;
            default:   next_state = S0;
        endcase
    end

    // Moore outputs combinational logic before registering
    wire disc_w = (state == S5) && (in_ == 1'b0);
    wire flag_w = (state == S6) && (in_ == 1'b0);
    // err asserted when next_state is S7 (error condition detected now)
    wire err_w  = (next_state == S7);

    // Sequential registers for state and outputs with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            state <= next_state;
            disc  <= disc_w;
            flag  <= flag_w;
            err   <= err_w;
        end
    end

endmodule