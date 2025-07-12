module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states
    localparam IDLE = 0;
    localparam S1   = 1;  // 1
    localparam S2   = 2;  // 11
    localparam S3   = 3;  // 111
    localparam S4   = 4;  // 1111
    localparam S5   = 5;  // 11111
    localparam S6   = 6;  // 111111
    localparam S7   = 7;  // 1111111+

    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= (1 << IDLE);
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (remain unchanged unless conditions met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            case (1'b1)
                state[IDLE]: begin
                    if (in) state <= (1 << S1);
                end
                state[S1]: begin
                    if (in) state <= (1 << S2);
                    else state <= (1 << IDLE);
                end
                state[S2]: begin
                    if (in) state <= (1 << S3);
                    else state <= (1 << IDLE);
                end
                state[S3]: begin
                    if (in) state <= (1 << S4);
                    else state <= (1 << IDLE);
                end
                state[S4]: begin
                    if (in) state <= (1 << S5);
                    else state <= (1 << IDLE);
                end
                state[S5]: begin
                    if (in) state <= (1 << S6);
                    else begin
                        state <= (1 << IDLE);
                        disc <= 1;  // Discard after 5 ones
                    end
                end
                state[S6]: begin
                    if (in) state <= (1 << S7);
                    else begin
                        state <= (1 << IDLE);
                        flag <= 1;  // Flag after 6 ones
                    end
                end
                state[S7]: begin
                    if (in) err <= 1;  // Error for 7+ ones
                    else state <= (1 << IDLE);
                end
            endcase
        end
    end

endmodule