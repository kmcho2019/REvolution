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

    // Main states
    typedef enum {WALK, FALL, DIG} state_t;
    reg [1:0] state;
    
    // Direction register (0=left, 1=right)
    reg direction;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0; // Start walking left
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else begin
                        // Handle direction changes
                        if (bump_left) direction <= 1;
                        if (bump_right) direction <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) state <= WALK;
                end
                
                DIG: begin
                    if (~ground) state <= FALL;
                    else if (~dig) state <= WALK;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule