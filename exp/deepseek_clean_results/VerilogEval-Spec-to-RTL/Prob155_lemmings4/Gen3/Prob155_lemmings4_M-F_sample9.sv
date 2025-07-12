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
    parameter WL = 3'd0;  // Walk Left
    parameter WR = 3'd1;  // Walk Right
    parameter FL = 3'd2;  // Falling
    parameter DG = 3'd3;  // Digging
    parameter SP = 3'd4;  // Splattered
    
    reg [2:0] state, next_state;
    reg [4:0] fall_counter;
    reg saved_dir;  // 0=right, 1=left
    
    // State transition logic with strict priorities
    always @(*) begin
        case (state)
            WL: begin
                if (!ground) begin
                    next_state = FL;
                end else if (dig) begin
                    next_state = DG;
                end else if (bump_left) begin
                    next_state = WR;
                end else begin
                    next_state = WL;
                end
            end
            
            WR: begin
                if (!ground) begin
                    next_state = FL;
                end else if (dig) begin
                    next_state = DG;
                end else if (bump_right) begin
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end
            
            FL: begin
                if (ground) begin
                    next_state = (fall_counter > 20) ? SP : (saved_dir ? WL : WR);
                end else begin
                    next_state = FL;
                end
            end
            
            DG: begin
                if (!ground) begin
                    next_state = FL;
                end else begin
                    next_state = DG;
                end
            end
            
            SP: next_state = SP;
            
            default: next_state = WL;
        endcase
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            saved_dir <= 1'b1;  // Start walking left
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Save direction when transitioning from walking to falling/digging
            if ((state == WL || state == WR) && (next_state == FL || next_state == DG)) begin
                saved_dir <= (state == WL);
            end
            
            // Update fall counter
            if (state == FL) begin
                if (!ground) begin
                    fall_counter <= fall_counter + 1;
                end else begin
                    fall_counter <= 0;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left  = (state == WL) && (state != SP);
    assign walk_right = (state == WR) && (state != SP);
    assign aaah       = (state == FL);
    assign digging    = (state == DG);
    
endmodule