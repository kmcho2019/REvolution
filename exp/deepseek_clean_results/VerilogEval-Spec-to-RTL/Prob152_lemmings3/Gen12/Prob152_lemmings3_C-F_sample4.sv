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
    
    // State transition logic
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
    
    // Direction update logic (separated for better timing)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
        end else if (state == WALK && ground && ~dig) begin
            // Only update direction when walking on ground and not digging
            case ({bump_left, bump_right})
                2'b10: direction <= 1'b1; // bump_left
                2'b01: direction <= 1'b0; // bump_right
                default: ; // maintain direction
            endcase
        end
    end
    
    // Output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule