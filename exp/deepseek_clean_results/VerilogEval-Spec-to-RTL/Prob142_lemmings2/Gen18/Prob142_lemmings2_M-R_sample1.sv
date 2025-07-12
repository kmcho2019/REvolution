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

    // State definitions
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    // Direction definitions
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    reg direction;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
        end
        else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                end
                else if ((bump_left && (direction == LEFT)) || 
                         (bump_right && (direction == RIGHT))) begin
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

    // Output assignments
    assign walk_left = (state == WALK) && (direction == LEFT);
    assign walk_right = (state == WALK) && (direction == RIGHT);
    assign aaah = (state == FALL);

endmodule