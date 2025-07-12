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
    localparam FALLING_LEFT = 2'b10;
    localparam FALLING_RIGHT = 2'b11;
    
    reg [1:0] state;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end
        else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING_LEFT;
                    end
                    else if (bump_left) begin
                        state <= WALK_RIGHT;
                    end
                end
                
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING_RIGHT;
                    end
                    else if (bump_right) begin
                        state <= WALK_LEFT;
                    end
                end
                
                FALLING_LEFT: begin
                    if (ground) begin
                        state <= WALK_LEFT;
                    end
                end
                
                FALLING_RIGHT: begin
                    if (ground) begin
                        state <= WALK_RIGHT;
                    end
                end
            endcase
        end
    end
    
    // Output logic - pure Moore style
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING_LEFT) || (state == FALLING_RIGHT);

endmodule