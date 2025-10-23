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

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end
        else case (state)
            WALK: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG;
                else if (bump_left || bump_right)
                    direction <= bump_left;
            end
            
            FALL: if (ground) state <= WALK;
            
            DIG: if (!ground) state <= FALL;
        endcase
    end

    // Output logic
    assign walk_left  = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule