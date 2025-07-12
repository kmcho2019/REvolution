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
    reg [3:0] state;
    parameter WALK  = 4'b0001;
    parameter FALL  = 4'b0010;
    parameter DIG   = 4'b0100;
    parameter SPLAT = 4'b1000;

    reg dir;  // 0=left, 1=right
    reg [4:0] fall_counter;

    // Next state logic (combinational)
    wire next_walk  = (state == WALK) & ground & ~dig;
    wire next_fall  = (~ground) | (state == DIG & ~ground);
    wire next_dig   = (state == WALK) & ground & dig;
    wire next_splat = (state == FALL) & ground & (fall_counter > 20);

    // State transition (sequential)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            fall_counter <= 0;
        end else begin
            // Priority: splat > fall > dig > walk
            if (next_splat) begin
                state <= SPLAT;
            end else if (next_fall) begin
                state <= FALL;
                fall_counter <= 0;
            end else if (next_dig) begin
                state <= DIG;
            end else begin
                state <= WALK;
            end

            // Update fall counter
            if (state == FALL) begin
                fall_counter <= fall_counter + 1;
            end

            // Update direction when walking and bumped
            if (state == WALK && ground && ~dig) begin
                if (bump_left) dir <= 1;
                if (bump_right) dir <= 0;
            end
        end
    end

    // Output assignments
    assign walk_left  = (state == WALK) & ~dir & (state != SPLAT);
    assign walk_right = (state == WALK) & dir & (state != SPLAT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule