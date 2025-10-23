module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // State encoding: bit1 = falling, bit0 = direction (0=left,1=right)
    reg [1:0] state, next_state;

    // Combinational next_state logic
    always @(*) begin
        next_state = state; // default hold

        if (state[1] == 1'b0) begin
            // walking state
            if (ground == 1'b0) begin
                // start falling, keep direction
                next_state = {1'b1, state[0]};
            end else begin
                // on ground and walking: update direction if bumped
                if (bump_left || bump_right) begin
                    if (bump_left && bump_right) begin
                        // both bumps: flip direction
                        next_state = {1'b0, ~state[0]};
                    end else if (bump_left) begin
                        // bump left -> walk right (1)
                        next_state = {1'b0, 1'b1};
                    end else /* bump_right */ begin
                        // bump right -> walk left (0)
                        next_state = {1'b0, 1'b0};
                    end
                end else begin
                    // no bumps, keep walking same direction
                    next_state = state;
                end
            end
        end else begin
            // falling state
            if (ground == 1'b1) begin
                // landed, resume walking same direction
                next_state = {1'b0, state[0]};
            end else begin
                // keep falling, no direction change
                next_state = state;
            end
        end
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // start walking left
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] &  state[0];

endmodule