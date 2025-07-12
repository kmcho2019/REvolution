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

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if (state == FL || state == FR) begin
                fall_timer <= ground ? 0 : fall_timer + 1;
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
                    next_state = state[0] ? FR : FL;  // Fall has highest priority
                end else if (dig) begin
                    next_state = state[0] ? DR : DL;  // Dig comes next
                end else if ((state == WL && bump_left) || (state == WR && bump_right)) begin
                    next_state = state[0] ? WL : WR;  // Then bump handling
                end else begin
                    next_state = state;  // Default: keep current state
                end
            end
            
            FL, FR: begin
                if (ground) begin
                    next_state = (fall_timer >= 20) ? SP : 
                                 (state[0] ? WR : WL);
                end else begin
                    next_state = state;
                end
            end
            
            DL, DR: begin
                if (~ground) begin
                    next_state = state[0] ? FR : FL;
                end else begin
                    next_state = state;
                end
            end
            
            SP: next_state = SP;
            
            default: next_state = WL;
        endcase
    end

    // Output logic
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule