module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State encoding using localparams (2 bits)
localparam WALK = 2'd0;
localparam FALL = 2'd1;
localparam DIG  = 2'd2;

reg [1:0] mode, mode_next;
reg dir, dir_next; // 0=left, 1=right

// Next-state and direction logic combinational block
always @* begin
    mode_next = mode;
    dir_next  = dir;

    case (mode)
        WALK: begin
            if (!ground) begin
                // Fall if no ground, bump ignored here
                mode_next = FALL;
            end else if (dig) begin
                // Start digging only on ground and walking
                mode_next = DIG;
            end else begin
                // Only switch direction if bumped and walking on ground
                if (bump_left || bump_right) begin
                    // Switch direction regardless of single or both bumps
                    dir_next = ~dir;
                end
            end
        end

        FALL: begin
            if (ground)
                mode_next = WALK;
            // Direction unchanged during fall
        end

        DIG: begin
            if (!ground)
                mode_next = FALL;
            // Direction unchanged during dig
        end
    endcase
end

// Sequential logic for mode and direction update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALK;
        dir  <= 1'b0;  // start walking left
    end else begin
        mode <= mode_next;
        dir  <= dir_next;
    end
end

// Outputs driven by current state and direction (Moore outputs)
assign walk_left  = (mode == WALK) && (dir == 1'b0);
assign walk_right = (mode == WALK) && (dir == 1'b1);
assign aaah       = (mode == FALL);
assign digging    = (mode == DIG);

endmodule