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

    // State transitions with optimized priority handling
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
                    end else if (bump_left ^ bump_right) begin
                        direction <= bump_left;
                    end
                    // Simultaneous bumps toggle direction
                    else if (bump_left & bump_right) begin
                        direction <= ~direction;
                    end
                end
                
                FALL: if (ground) state <= WALK;
                
                DIG: if (!ground) state <= FALL;
            endcase
        end
    end

    // Optimized output logic
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule