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

    // Combined state and direction encoding
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL       = 2'b10;
    parameter DIG        = 2'b11;

    reg [1:0] state;

    // State transitions with optimized priority logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else case (state)
            WALK_LEFT: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG;
                else if (bump_left) state <= WALK_RIGHT;
            end
            
            WALK_RIGHT: begin
                if (!ground)      state <= FALL;
                else if (dig)     state <= DIG;
                else if (bump_right) state <= WALK_LEFT;
            end
            
            FALL: if (ground) state <= state[0] ? WALK_RIGHT : WALK_LEFT;
            
            DIG: if (!ground) state <= FALL;
        endcase
    end

    // Optimized output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule