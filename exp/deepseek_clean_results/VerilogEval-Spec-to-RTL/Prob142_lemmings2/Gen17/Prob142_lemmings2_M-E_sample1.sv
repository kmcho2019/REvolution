module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // States
    localparam WALK = 1'b0;
    localparam FALL = 1'b1;
    
    reg state;
    reg direction;  // 0=left, 1=right
    reg prev_bump_left, prev_bump_right;
    
    // Edge detection for bumps
    wire bump_left_edge = bump_left && !prev_bump_left;
    wire bump_right_edge = bump_right && !prev_bump_right;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;  // Start walking left
            prev_bump_left <= 1'b0;
            prev_bump_right <= 1'b0;
        end else begin
            // Store previous bump values for edge detection
            prev_bump_left <= bump_left;
            prev_bump_right <= bump_right;
            
            // State transitions
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if ((direction && bump_right_edge) || 
                               (!direction && bump_left_edge)) begin
                        direction <= ~direction;
                    end
                end
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    
endmodule