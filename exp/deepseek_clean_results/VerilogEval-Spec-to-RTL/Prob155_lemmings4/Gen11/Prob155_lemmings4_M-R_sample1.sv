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
    localparam [2:0]
        WALK_LEFT  = 3'b000,
        WALK_RIGHT = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101,
        SPLATTERED = 3'b110;

    reg [2:0] state;
    reg [4:0] fall_timer;

    // Next state logic
    wire [2:0] next_state;
    assign next_state = 
        (state == SPLATTERED) ? SPLATTERED :
        (!ground) ? ((state[1:0] == 2'b00) ? FALL_LEFT : 
                    (state[1:0] == 2'b01) ? FALL_RIGHT : state) :
        (state == FALL_LEFT || state == FALL_RIGHT) ? 
            (fall_timer > 20 ? SPLATTERED : 
             (state == FALL_LEFT ? WALK_LEFT : WALK_RIGHT)) :
        ((state == WALK_LEFT || state == WALK_RIGHT) && dig) ? 
            (state == WALK_LEFT ? DIG_LEFT : DIG_RIGHT) :
        (state == DIG_LEFT || state == DIG_RIGHT) ? state :
        (state == WALK_LEFT && bump_left) ? WALK_RIGHT :
        (state == WALK_RIGHT && bump_right) ? WALK_LEFT :
        state;

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Fall timer logic
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                if (!ground) begin
                    fall_timer <= fall_timer + 1;
                end else begin
                    fall_timer <= 0;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule