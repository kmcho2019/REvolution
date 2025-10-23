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

    // State encoding parameters
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;
    
    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) 
                        state <= FALL_LEFT;
                    else if (bump_left)
                        state <= WALK_RIGHT;
                end
                WALK_RIGHT: begin
                    if (!ground)
                        state <= FALL_RIGHT;
                    else if (bump_right)
                        state <= WALK_LEFT;
                end
                FALL_LEFT: begin
                    if (ground)
                        state <= WALK_LEFT;
                end
                FALL_RIGHT: begin
                    if (ground)
                        state <= WALK_RIGHT;
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = state[1]; // All falling states have MSB set

endmodule