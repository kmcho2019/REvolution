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
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state;
    reg direction; // 0=left, 1=right

    // Optimized state transitions with direction toggle optimization
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end
        else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;      // Highest priority: fall
                    end
                    else if (dig) begin
                        state <= DIG;       // Medium priority: dig
                    end
                    else if ((bump_left && direction) || (bump_right && !direction)) begin
                        // Only toggle direction if needed (reduces power)
                        direction <= ~direction;
                    end
                end
                
                FALL: if (ground) state <= WALK;
                
                DIG: if (!ground) state <= FALL;
            endcase
        end
    end

    // Output logic - pure Moore
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule