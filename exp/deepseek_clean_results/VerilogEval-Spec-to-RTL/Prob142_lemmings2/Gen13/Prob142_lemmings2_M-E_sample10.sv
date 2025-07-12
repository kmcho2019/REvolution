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
    localparam FALL_LEFT = 2'b10;
    localparam FALL_RIGHT = 2'b11;
    
    reg [1:0] state;

    // Edge detection for bump signals
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            case (state)
                LEFT: begin
                    if (!ground) 
                        state <= FALL_LEFT;
                    else if (bump_left_edge)
                        state <= RIGHT;
                end
                
                RIGHT: begin
                    if (!ground)
                        state <= FALL_RIGHT;
                    else if (bump_right_edge)
                        state <= LEFT;
                end
                
                FALL_LEFT: begin
                    if (ground)
                        state <= LEFT;
                end
                
                FALL_RIGHT: begin
                    if (ground)
                        state <= RIGHT;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_LEFT) || (state == FALL_RIGHT);

endmodule