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

    // State encoding - 2 bits for state + 1 bit for direction
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    
    // Next state and direction logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;  // Highest priority: fall
                    end else if (dig) begin
                        state <= DIG;   // Medium priority: dig
                    end else begin
                        // Only change direction when walking on ground
                        if (bump_left && !direction) begin
                            direction <= 1;
                        end else if (bump_right && direction) begin
                            direction <= 0;
                        end
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= WALK;  // Return to walking when ground reappears
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;  // Fall when digging through ground
                    end
                end
            endcase
        end
    end
    
    // Output logic - purely combinatorial
    assign walk_left  = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule