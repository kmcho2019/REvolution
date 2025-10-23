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

    // State encoding
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT = 2'b10;
    localparam FALL_RIGHT = 2'b11;
    
    reg [1:0] state;
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: 
                    if (!ground) state <= FALL_LEFT;
                    else if (bump_left) state <= WALK_RIGHT;
                
                WALK_RIGHT: 
                    if (!ground) state <= FALL_RIGHT;
                    else if (bump_right) state <= WALK_LEFT;
                
                FALL_LEFT: 
                    if (ground) state <= WALK_LEFT;
                
                FALL_RIGHT: 
                    if (ground) state <= WALK_RIGHT;
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule