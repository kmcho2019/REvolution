module TopModule(
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

// State encoding - 3 bits to encode direction and activity
localparam WL   = 3'd0; // Walking left
localparam WR   = 3'd1; // Walking right
localparam FA_L = 3'd2; // Falling left
localparam FA_R = 3'd3; // Falling right
localparam DG_L = 3'd4; // Digging left
localparam DG_R = 3'd5; // Digging right

reg [2:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
    end else begin
        state <= next_state;
    end
end

// Next state logic with priority: fall > dig > bump direction
always @(*) begin
    next_state = state; // default hold

    case (state)
        WL: begin
            if (!ground) begin
                // Fall, remember direction left
                next_state = FA_L;
            end else if (dig) begin
                // Digging left
                next_state = DG_L;
            end else if (bump_left || bump_right) begin
                // Switch to walking right
                next_state = WR;
            end else begin
                next_state = WL;
            end
        end

        WR: begin
            if (!ground) begin
                // Fall, remember direction right
                next_state = FA_R;
            end else if (dig) begin
                // Digging right
                next_state = DG_R;
            end else if (bump_left || bump_right) begin
                // Switch to walking left
                next_state = WL;
            end else begin
                next_state = WR;
            end
        end

        FA_L: begin
            if (ground) begin
                // Land and resume walking left
                next_state = WL;
            end else begin
                next_state = FA_L;
            end
        end

        FA_R: begin
            if (ground) begin
                // Land and resume walking right
                next_state = WR;
            end else begin
                next_state = FA_R;
            end
        end

        DG_L: begin
            if (!ground) begin
                // Start falling left
                next_state = FA_L;
            end else begin
                next_state = DG_L;
            end
        end

        DG_R: begin
            if (!ground) begin
                // Start falling right
                next_state = FA_R;
            end else begin
                next_state = DG_R;
            end
        end

        default: next_state = WL; // safe default
    endcase
end

// Outputs depend only on state (Moore)
// Walking left: WL state
assign walk_left = (state == WL);
// Walking right: WR state
assign walk_right = (state == WR);
// Falling: any FA_* state
assign aaah = (state == FA_L) || (state == FA_R);
// Digging: any DG_* state
assign digging = (state == DG_L) || (state == DG_R);

endmodule