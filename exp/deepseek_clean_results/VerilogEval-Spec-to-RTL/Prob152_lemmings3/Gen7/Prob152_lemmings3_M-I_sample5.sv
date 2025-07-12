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
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG  = 3'b100;
    
    reg [2:0] state;
    reg direction;  // 0=left, 1=right
    reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: // WALK
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end
                state[1]: // FALL
                    if (ground) state <= WALK;
                state[2]: // DIG
                    if (!ground) state <= FALL;
            endcase
        end
    end

    // Direction update (only in WALK state)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end else if (state[0]) begin // Only update direction in WALK state
            case ({bump_left, bump_right})
                2'b10: direction <= 1'b1;
                2'b01: direction <= 1'b0;
                2'b11: direction <= ~direction;
            endcase
        end
    end

    // Registered outputs
    always @(posedge clk) begin
        walk_left_reg  <= state[0] & ~direction;
        walk_right_reg <= state[0] & direction;
        aaah_reg       <= state[1];
        digging_reg    <= state[2];
    end

    assign walk_left  = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah       = aaah_reg;
    assign digging    = digging_reg;

endmodule