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
    
    // Direction update logic (only in WALK state)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (state == WALK) begin
            if (bump_left)
                direction <= 1'b1;
            else if (bump_right)
                direction <= 1'b0;
        end
    end
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
        end else begin
            case (state)
                WALK: begin
                    if (~ground)
                        state <= FALL;
                    else if (dig)
                        state <= DIG;
                end
                
                FALL: begin
                    if (ground)
                        state <= WALK;
                end
                
                DIG: begin
                    if (~ground)
                        state <= FALL;
                end
            endcase
        end
    end
    
    // Continuous output assignments
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule