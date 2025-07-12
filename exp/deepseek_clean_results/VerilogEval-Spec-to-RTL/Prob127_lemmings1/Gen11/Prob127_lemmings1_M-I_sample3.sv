module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding using localparam
    localparam WALK_LEFT = 1'b0;
    localparam WALK_RIGHT = 1'b1;
    
    reg state;

    // State register with optimized transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: 
                    if (bump_left) state <= WALK_RIGHT;
                WALK_RIGHT: 
                    if (bump_right) state <= WALK_LEFT;
            endcase
        end
    end

    // Output logic remains direct state comparison
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule