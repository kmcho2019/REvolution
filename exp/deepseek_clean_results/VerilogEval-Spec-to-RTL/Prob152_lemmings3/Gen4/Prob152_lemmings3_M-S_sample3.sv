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

    // States
    parameter WALK = 0;
    parameter FALL = 1;
    parameter DIG  = 2;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right

    // Next state and direction logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end else if (dig) begin
                        state <= DIG;
                    end else if (bump_left && !direction) begin
                        direction <= 1;
                    end else if (bump_right && direction) begin
                        direction <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) state <= WALK;
                end
                
                DIG: begin
                    if (!ground) state <= FALL;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule