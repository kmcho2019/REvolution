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
    reg direction; // 0=left, 1=right
    
    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0; // Start walking left
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL; // Highest priority
                    end else if (dig) begin
                        state <= DIG; // Medium priority
                    end else begin
                        // Only check bumps if no higher priority condition
                        if (bump_left) begin
                            direction <= 1'b1;
                        end else if (bump_right) begin
                            direction <= 1'b0;
                        end
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
    
    // Minimal output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule