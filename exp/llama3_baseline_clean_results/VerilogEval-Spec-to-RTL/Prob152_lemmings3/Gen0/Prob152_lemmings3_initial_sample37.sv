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

// Define the states
enum logic [1:0] {
    WalkingLeft,
    WalkingRight,
    Falling,
    Digging
} state, nextState;

// Define the output logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    case (state)
        WalkingLeft: walk_left = 1'b1;
        WalkingRight: walk_right = 1'b1;
        Falling: aaah = 1'b1;
        Digging: digging = 1'b1;
    endcase
end

// Define the next state logic
always_comb begin
    case (state)
        WalkingLeft: begin
            if (~ground) begin
                nextState = Falling;
            end else if (dig) begin
                nextState = Digging;
            end else if (bump_left) begin
                nextState = WalkingRight;
            end else if (bump_right) begin
                nextState = WalkingLeft;
            end else begin
                nextState = WalkingLeft;
            end
        end
        WalkingRight: begin
            if (~ground) begin
                nextState = Falling;
            end else if (dig) begin
                nextState = Digging;
            end else if (bump_left) begin
                nextState = WalkingLeft;
            end else if (bump_right) begin
                nextState = WalkingLeft;
            end else begin
                nextState = WalkingRight;
            end
        end
        Falling: begin
            if (ground) begin
                // Resume the previous walking direction
                if (bump_left && bump_right) begin
                    nextState = state == WalkingLeft ? WalkingRight : WalkingLeft;
                end else if (bump_left) begin
                    nextState = WalkingRight;
                end else if (bump_right) begin
                    nextState = WalkingLeft;
                end else begin
                    nextState = state == WalkingLeft ? WalkingLeft : WalkingRight;
                end
            end else begin
                nextState = Falling;
            end
        end
        Digging: begin
            if (~ground) begin
                nextState = Falling;
            end else begin
                nextState = Digging;
            end
        end
    endcase
end

// Define the sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WalkingLeft;
    end else begin
        state <= nextState;
    end
end

endmodule