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

    // State encoding:
    // bit1: falling (1) or walking (0)
    // bit0: direction (0=left, 1=right)
    reg [1:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default hold

        if (state[1] == 1'b0) begin
            // walking
            if (ground == 1'b0) begin
                // start falling, keep direction
                next_state = {1'b1, state[0]};
            end else begin
                // on ground and walking: bump determines direction change
                // if bump_left or bump_right (or both) flip or set direction accordingly
                if (bump_left && bump_right) begin
                    // flip direction
                    next_state = {1'b0, ~state[0]};
                end else if (bump_left) begin
                    // bump left -> walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // bump right -> walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    next_state = state;
                end
            end
        end else begin
            // falling
            if (ground == 1'b1) begin
                // stop falling, keep direction
                next_state = {1'b0, state[0]};
            end
            // else remain falling, no direction change
        end
    end

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (areset) begin
            state <= 2'b00; // walk left initial state
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs
    assign aaah       = state[1];
    assign walk_left  = ~state[1] & ~state[0];
    assign walk_right = ~state[1] & state[0];

endmodule