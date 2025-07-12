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
    localparam [2:0]
        WL = 3'b000,  // Walk left
        WR = 3'b001,  // Walk right
        FL = 3'b010,  // Fall left
        FR = 3'b011,  // Fall right
        DL = 3'b100,  // Dig left
        DR = 3'b101,  // Dig right
        SP = 3'b110;  // Splat
    
    reg [2:0] state, next_state;
    reg [4:0] fall_timer;

    // State transition and timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Timer logic - only count while falling
            if (state == FL || state == FR) begin
                if (~ground) begin
                    fall_timer <= fall_timer + 1;
                end else begin
                    fall_timer <= 0;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state logic with strict priorities
    always @(*) begin
        case (state)
            WL, WR: begin
                if (~ground) begin
                    // Highest priority: fall when ground disappears
                    next_state = state[0] ? FR : FL;
                end else if (dig) begin
                    // Next priority: dig when commanded
                    next_state = state[0] ? DR : DL;
                end else if ((state == WL && bump_left) || 
                           (state == WR && bump_right)) begin
                    // Lowest priority: change direction when bumped
                    next_state = state[0] ? WL : WR;
                end else begin
                    next_state = state;  // No change
                end
            end
            
            FL, FR: begin
                if (ground) begin
                    // Check for splat condition when landing
                    if (fall_timer >= 20) begin
                        next_state = SP;
                    end else begin
                        // Resume walking in original direction
                        next_state = state[0] ? WR : WL;
                    end
                end else begin
                    next_state = state;  // Keep falling
                end
            end
            
            DL, DR: begin
                if (~ground) begin
                    // Start falling when ground disappears while digging
                    next_state = state[0] ? FR : FL;
                end else begin
                    next_state = state;  // Keep digging
                end
            end
            
            SP: next_state = SP;  // Permanent splat state
            
            default: next_state = WL;
        endcase
    end

    // Output logic - simple assignments based on current state
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule