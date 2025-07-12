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

typedef enum logic [1:0] {
    WALK = 2'd0,
    FALL = 2'd1,
    DIG  = 2'd2
} mode_t;

mode_t mode, mode_next;
logic dir, dir_next; // 0=left, 1=right

// Synchronize asynchronous inputs to clk domain to reduce glitches/metastability
logic bump_left_sync, bump_right_sync, ground_sync, dig_sync;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        bump_left_sync  <= 1'b0;
        bump_right_sync <= 1'b0;
        ground_sync     <= 1'b0;
        dig_sync        <= 1'b0;
    end else begin
        bump_left_sync  <= bump_left;
        bump_right_sync <= bump_right;
        ground_sync     <= ground;
        dig_sync        <= dig;
    end
end

// Combinational block for next state and next direction logic
always @* begin
    mode_next = mode;
    dir_next = dir;

    case (mode)
        WALK: begin
            if (!ground_sync) begin
                mode_next = FALL;
                // dir_next unchanged when falling
            end else if (dig_sync) begin
                mode_next = DIG;
                // dir_next unchanged when digging
            end else if (bump_left_sync || bump_right_sync) begin
                // Switch direction on bump(s)
                if (bump_left_sync && bump_right_sync)
                    dir_next = ~dir;
                else if (bump_left_sync)
                    dir_next = 1'b1; // walk right
                else
                    dir_next = 1'b0; // walk left
            end
            // else stay in WALK with current direction
        end

        FALL: begin
            if (ground_sync)
                mode_next = WALK;
            // Direction unchanged during fall
        end

        DIG: begin
            if (!ground_sync)
                mode_next = FALL;
            // Direction unchanged during dig
        end
    endcase
end

// Sequential block to update state and direction on clock and async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir <= 1'b0; // start walking left
    end else begin
        mode <= mode_next;
        dir <= dir_next;
    end
end

// Output assignments for Moore machine outputs
assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule