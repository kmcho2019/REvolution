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
    // Hierarchical state encoding
    parameter WL = 3'b000; // Walk left
    parameter WR = 3'b001; // Walk right
    parameter DL = 3'b010; // Dig left
    parameter DR = 3'b011; // Dig right
    parameter FL = 3'b100; // Fall left (remember direction)
    parameter FR = 3'b101; // Fall right (remember direction)
    
    reg [2:0] state, next_state;
    
    // State transitions - split into parallel always blocks for optimization
    always @(*) begin
        // Default: stay in current state
        next_state = state;
        
        // Handle falling transitions (highest priority)
        if ((state == WL || state == WR || state == DL || state == DR) && !ground) begin
            next_state = (state == WL || state == DL) ? FL : FR;
        end
    end
    
    always @(*) begin
        // Handle ground recovery (medium priority)
        if ((state == FL || state == FR) && ground) begin
            next_state = (state == FL) ? WL : WR;
        end
    end
    
    always @(*) begin
        // Handle digging transitions (only when walking)
        if ((state == WL || state == WR) && ground && dig) begin
            next_state = (state == WL) ? DL : DR;
        end
    end
    
    always @(*) begin
        // Handle bump transitions (lowest priority, only when walking)
        if (state == WL && bump_left) begin
            next_state = WR;
        end
        if (state == WR && bump_right) begin
            next_state = WL;
        end
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL; // Start walking left
        end else begin
            state <= next_state;
        end
    end
    
    // Output logic - direct state mapping
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);
    
endmodule