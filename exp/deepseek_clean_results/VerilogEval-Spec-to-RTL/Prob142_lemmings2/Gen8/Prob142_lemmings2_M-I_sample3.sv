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
    reg direction;  // 0=left, 1=right
    reg falling;
    reg prev_ground;
    
    // Falling state logic with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            falling <= 1'b0;
            prev_ground <= 1'b1;
        end
        else begin
            prev_ground <= ground;
            if (!falling && !ground) begin
                falling <= 1'b1;
            end
            else if (falling && ground) begin
                falling <= 1'b0;
            end
        end
    end
    
    // Direction logic with edge detection
    wire bump_event = (direction ? bump_right : bump_left) && ground && !falling;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end
        else if (bump_event) begin
            direction <= ~direction;
        end
    end
    
    // Optimized output logic
    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;
endmodule