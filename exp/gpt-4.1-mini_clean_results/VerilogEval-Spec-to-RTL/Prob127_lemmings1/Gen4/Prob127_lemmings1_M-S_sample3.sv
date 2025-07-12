module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    output reg  walk_left,
    output reg  walk_right
);

    reg state;  // 0 = WALK_LEFT, 1 = WALK_RIGHT
    reg next_state;

    always @(*) begin
        if (state == 1'b0) begin
            // Currently walking left
            if (bump_left || bump_right)
                next_state = 1'b1; // Switch to walking right
            else
                next_state = 1'b0; // Stay walking left
        end else begin
            // Currently walking right
            if (bump_left || bump_right)
                next_state = 1'b0; // Switch to walking left
            else
                next_state = 1'b1; // Stay walking right
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to WALK_LEFT
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs: determined by state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
        end else begin
            walk_left  <= (state == 1'b0);
            walk_right <= (state == 1'b1);
        end
    end

endmodule