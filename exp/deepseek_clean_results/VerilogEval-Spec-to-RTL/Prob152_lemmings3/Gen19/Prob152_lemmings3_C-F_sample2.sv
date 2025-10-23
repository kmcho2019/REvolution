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
            direction <= 1'b0; // Start walking left
        end else begin
            case (state)
                WALK: begin
                    if (~ground) begin
                        state <= FALL; // Highest priority
                    end else if (dig) begin
                        state <= DIG; // Medium priority
                    end else if (bump_left || bump_right) begin
                        // Only update direction when walking
                        if (bump_right) direction <= 1'b0;
                        else if (bump_left) direction <= 1'b1;
                    end
                end
                
                FALL: begin
                    if (ground) state <= WALK;
                end
                
                DIG: begin
                    if (~ground) state <= FALL;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule