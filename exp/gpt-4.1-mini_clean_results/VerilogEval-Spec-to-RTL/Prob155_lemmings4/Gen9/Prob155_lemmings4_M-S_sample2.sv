module TopModule (
    input  clk,
    input  areset,       // asynchronous posedge reset
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits):
    // bit2=fall/splat indicator:
    //   0: walking or digging
    //   1: falling or splatting
    // bit1=digging flag (only valid if bit2=0)
    // bit0=direction: 0=left, 1=right
    localparam WALK_L   = 3'b000;
    localparam WALK_R   = 3'b001;
    localparam DIG_L    = 3'b010;
    localparam DIG_R    = 3'b011;
    localparam FALL_L   = 3'b100;
    localparam FALL_R   = 3'b101;
    localparam SPLAT_L  = 3'b110; // splat states encode direction, but outputs are off anyway
    localparam SPLAT_R  = 3'b111;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 5'd0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_timer = (state[2]) ? fall_timer : 5'd0; // count only if falling/splat

        case (state)
            // Walking states
            WALK_L, WALK_R: begin
                if (!ground) begin
                    // fall starts
                    next_state = (state == WALK_L) ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1;
                end else if (dig) begin
                    // start digging
                    next_state = (state == WALK_L) ? DIG_L : DIG_R;
                end else begin
                    // bump check
                    if (bump_left && bump_right) begin
                        // reverse direction
                        next_state = (state == WALK_L) ? WALK_R : WALK_L;
                    end else if (bump_left) begin
                        next_state = WALK_R;
                    end else if (bump_right) begin
                        next_state = WALK_L;
                    end
                end
            end

            // Digging states
            DIG_L, DIG_R: begin
                if (!ground) begin
                    // start falling from digging
                    next_state = (state == DIG_L) ? FALL_L : FALL_R;
                    next_fall_timer = 5'd1;
                end
                // else keep digging
            end

            // Falling states
            FALL_L, FALL_R: begin
                if (ground) begin
                    // landed
                    if (fall_timer > 5'd20)
                        next_state = (state == FALL_L) ? SPLAT_L : SPLAT_R;
                    else
                        next_state = (state == FALL_L) ? WALK_L : WALK_R;
                    next_fall_timer = 5'd0;
                end else begin
                    // continue falling, saturate timer at 31
                    next_fall_timer = (fall_timer < 5'd31) ? fall_timer + 1 : 5'd31;
                end
            end

            // Splat states, no recovery
            SPLAT_L, SPLAT_R: begin
                next_state = state;
                next_fall_timer = 5'd0;
            end
        endcase
    end

    // Outputs (Moore)
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule