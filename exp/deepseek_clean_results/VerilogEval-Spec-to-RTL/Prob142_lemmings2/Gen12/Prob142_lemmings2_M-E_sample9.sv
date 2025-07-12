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
    localparam LEFT = 2'b00;
    localparam RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    
    reg [1:0] state;
    reg pre_fall_dir;  // 0=left, 1=right
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            pre_fall_dir <= 0;
        end
        else begin
            case (state)
                LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        pre_fall_dir <= 0;
                    end
                    else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                
                RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        pre_fall_dir <= 1;
                    end
                    else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        state <= pre_fall_dir ? RIGHT : LEFT;
                    end
                end
            endcase
        end
    end
    
    // Output logic - pure Moore style
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALLING);

endmodule