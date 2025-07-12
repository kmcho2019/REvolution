module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding: count of consecutive ones
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5,
        S6 = 3'd6,
        S7 = 3'd7; // 7 or more ones = error

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0; // hold error state if input=1, else reset
            default: next_state = S0;
        endcase
    end

    // Combinational outputs based on current state and input
    // disc: zero after exactly 5 ones (state S5 + input=0)
    // flag: zero after exactly 6 ones (state S6 + input=0)
    wire disc_w = (state == S5) && (in == 1'b0);
    wire flag_w = (state == S6) && (in == 1'b0);

    // err_reg controls err output, set if next_state is error state (S7), cleared otherwise
    reg err_reg;

    always @(posedge clk) begin
        if (reset) begin
            state   <= S0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
            err_reg <= 1'b0;
        end else begin
            state <= next_state;

            // Register disc and flag outputs: one cycle after detection
            disc <= disc_w;
            flag <= flag_w;

            // err_reg set if next_state is S7 (entering or staying in error)
            // cleared if next_state is not S7 (leaving error)
            err_reg <= (next_state == S7);

            // err output registered from err_reg to assert one cycle after detection
            err <= err_reg;
        end
    end

endmodule