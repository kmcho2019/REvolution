module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // State encoding:
    // 4 bits total: [3] output flag, [2:0] count of consecutive ones (0 to 6)
    // Output states have MSB=1 and count part used to differentiate:
    // disc  = 4'b1000 (8)
    // flag  = 4'b1001 (9)
    // error = 4'b1010 (10)
    // Normal counts: 0 to 6 (0000 to 0110)
    localparam
        DISC_STATE = 4'd8,
        FLAG_STATE = 4'd9,
        ERR_STATE  = 4'd10;

    reg [3:0] state, next_state;

    wire [2:0] count = state[2:0];

    // Next state logic
    always @(*) begin
        // Default: stay in current state (safe)
        next_state = 4'd0;

        if (state == DISC_STATE || state == FLAG_STATE) begin
            // After output state, transition depends on input bit:
            // in=0: go to count=0
            // in=1: go to count=1
            next_state = in ? 4'd1 : 4'd0;
        end else if (state == ERR_STATE) begin
            // Stay in error if input 1, else reset count=0
            next_state = in ? ERR_STATE : 4'd0;
        end else begin
            // Normal count states from 0 to 6
            if (in) begin
                // On '1' increment count, saturate at 6 max before error
                if (count < 6)
                    next_state = count + 1;
                else
                    // 7 or more consecutive ones -> error state
                    next_state = ERR_STATE;
            end else begin
                // On '0' input, check count for outputs or reset
                case (count)
                    5: next_state = DISC_STATE; // 5 ones + 0 -> disc state
                    6: next_state = FLAG_STATE; // 6 ones + 0 -> flag state
                    default: next_state = 4'd0; // else reset count
                endcase
            end
        end
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= 4'd0;
        else
            state <= next_state;
    end

    // Moore outputs based on current state
    assign disc = (state == DISC_STATE);
    assign flag = (state == FLAG_STATE);
    assign err  = (state == ERR_STATE);

endmodule