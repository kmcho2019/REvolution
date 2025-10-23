module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State definitions
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALL_LEFT = 2'b10;
    parameter FALL_RIGHT = 2'b11;
    
    reg [1:0] state;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: state <= (!ground) ? FALL_LEFT : 
                                  (bump_left) ? WALK_RIGHT : WALK_LEFT;
                WALK_RIGHT: state <= (!ground) ? FALL_RIGHT : 
                                   (bump_right) ? WALK_LEFT : WALK_RIGHT;
                FALL_LEFT: state <= (ground) ? WALK_LEFT : FALL_LEFT;
                FALL_RIGHT: state <= (ground) ? WALK_RIGHT : FALL_RIGHT;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule