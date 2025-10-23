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

// State encoding
localparam WL = 2'd0; // Walking left
localparam WR = 2'd1; // Walking right
localparam FA = 2'd2; // Falling (aaah)
localparam DG = 2'd3; // Digging

reg [1:0] state, next_state;
// To remember walking direction through falling/digging
// We'll store walking direction as state WL or WR.
// Falling and digging don't encode direction alone, so we keep a separate signal to remember direction.
reg dir; // 0 = left, 1 = right

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        dir <= 1'b0; // left
    end else begin
        state <= next_state;
        // Update direction only when walking
        if (next_state == WL) dir <= 1'b0;
        else if (next_state == WR) dir <= 1'b1;
        // For falling or digging, direction remains the same as before
    end
end

// Next state logic
always @(*) begin
    // Defaults
    next_state = state;

    case(state)
    WL: begin
        // priority: fall > dig > bump
        if (!ground) begin
            next_state = FA;
        end else if (dig) begin
            next_state = DG;
        end else if (bump_left || bump_right) begin
            // Switch direction if bumped on left or right or both
            // Since currently walking left, bump_left means bump on left, walk right
            // For walking left, bump_left means bump on side walking into, bump_right also triggers switch per problem statement
            // Actually problem states bump on either side switches direction when walking.
            // So both bumps or either bump cause switch.
            next_state = WR;
        end else begin
            next_state = WL;
        end
    end

    WR: begin
        // priority: fall > dig > bump
        if (!ground) begin
            next_state = FA;
        end else if (dig) begin
            next_state = DG;
        end else if (bump_left || bump_right) begin
            // Switch direction
            next_state = WL;
        end else begin
            next_state = WR;
        end
    end

    FA: begin
        // Falling: stay falling until ground is back, then resume walking same direction
        if (ground) begin
            // Resume walking in stored direction
            if (dir == 1'b0)
                next_state = WL;
            else
                next_state = WR;
        end else begin
            next_state = FA;
        end
    end

    DG: begin
        // Digging: continue digging while ground=1
        // When ground disappears, start falling
        if (!ground) begin
            next_state = FA;
        end else begin
            next_state = DG;
        end
    end

    default: next_state = WL; // safe default
    endcase
end

// Outputs: Moore machine, outputs depend on state
assign walk_left = (state == WL);
assign walk_right = (state == WR);
assign aaah = (state == FA);
assign digging = (state == DG);

endmodule