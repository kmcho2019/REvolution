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

    // State encoding
    localparam WALK_L = 3'b000;
    localparam WALK_R = 3'b001;
    localparam FALL   = 3'b010;
    localparam DIG_L  = 3'b011;
    localparam DIG_R  = 3'b100;
    localparam SPLAT  = 3'b101;
    
    reg [2:0] state, next_state;
    reg [4:0] fall_timer;
    reg direction; // 0=left, 1=right

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 0;
            direction <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FALL && !ground)
                fall_timer <= fall_timer + 1;
            else
                fall_timer <= 0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L, WALK_R: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = direction ? DIG_R : DIG_L;
                end else begin
                    // Handle direction changes
                    if (bump_left && !bump_right)
                        next_state = WALK_R;
                    else if (bump_right && !bump_left)
                        next_state = WALK_L;
                    else if (bump_left && bump_right)
                        next_state = direction ? WALK_L : WALK_R;
                    else
                        next_state = state;
                end
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_timer > 20)
                        next_state = SPLAT;
                    else
                        next_state = direction ? WALK_R : WALK_L;
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG_L, DIG_R: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = state;
            end
            
            SPLAT: next_state = SPLAT;
            
            default: next_state = WALK_L;
        endcase
    end

    // Update direction register
    always @(posedge clk) begin
        if (state == WALK_L) direction <= 0;
        else if (state == WALK_R) direction <= 1;
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule