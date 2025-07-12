module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // One-hot state encoding
    parameter WLK_L = 0;
    parameter WLK_R = 1;
    parameter DIG_L = 2;
    parameter DIG_R = 3;
    parameter FALL = 4;
    parameter SPLAT = 5;

    reg [5:0] state;
    reg [4:0] fall_counter;

    // Fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else begin
            if (state[FALL]) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 6'b000001;  // WLK_L
        end else begin
            case (1'b1)  // Synthesis will optimize this
                state[SPLAT]: state <= state;  // Stay in SPLAT

                state[FALL]: begin
                    if (ground) begin
                        state <= (fall_counter > 20) ? (6'b100000) : 
                               (state[WLK_L] || state[DIG_L]) ? (6'b000001) : (6'b000010);
                    end
                end

                state[DIG_L] || state[DIG_R]: begin
                    if (~ground) state <= 6'b001000;  // FALL
                end

                state[WLK_L] || state[WLK_R]: begin
                    if (~ground) begin
                        state <= 6'b001000;  // FALL
                    end else if (dig) begin
                        state <= state[WLK_L] ? 6'b000100 : 6'b001000;
                    end else if (bump_left || bump_right) begin
                        state <= (bump_left && ~bump_right) ? 6'b000010 : 
                               (bump_right && ~bump_left) ? 6'b000001 : 
                               state[WLK_L] ? 6'b000010 : 6'b000001;
                    end
                end

                default: state <= 6'b000001;  // Default to WLK_L
            endcase
        end
    end

    // Output assignments
    assign walk_left = state[WLK_L];
    assign walk_right = state[WLK_R];
    assign aaah = state[FALL];
    assign digging = state[DIG_L] || state[DIG_R];

endmodule