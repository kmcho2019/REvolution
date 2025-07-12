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
    
    reg [1:0] state;
    reg direction; // 0=left, 1=right
    
    // State transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                    end
                end
                
                DIG: begin
                    if (~ground) begin
                        state <= FALL;
                    end
                end
            endcase
        end
    end
    
    // Direction updates (only when walking)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (state == WALK) begin
            if (bump_left) begin
                direction <= 1'b1;
            end else if (bump_right) begin
                direction <= 1'b0;
            end
        end
    end
    
    // Output assignments
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule