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
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_cycles;

    // Next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;  // Highest priority: fall
                end else if (dig) begin
                    next_state = DIG;   // Next priority: dig
                end else begin
                    next_state = WALK;  // Default remains walking
                    // Handle direction changes only when walking on ground
                    if (bump_left && ~bump_right) direction = 1'b1;
                    if (bump_right && ~bump_left) direction = 1'b0;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = (fall_cycles > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                next_state = (~ground) ? FALL : DIG;
            end
            SPLAT: begin
                next_state = SPLAT;  // Terminal state
            end
            default: next_state = WALK;
        endcase
    end

    // State and counter updates
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
            fall_cycles <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALL) begin
                fall_cycles <= (~ground) ? fall_cycles + 1 : 0;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction & ~(state == SPLAT);
    assign walk_right = (state == WALK) & direction & ~(state == SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule