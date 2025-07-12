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

    // States
    localparam LEFT = 2'b00;
    localparam RIGHT = 2'b01;
    localparam FALL = 2'b10;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    
    // Edge detection for bump signals
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            direction <= 0;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else begin
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            case (state)
                LEFT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (bump_left_edge) begin
                        state <= RIGHT;
                        direction <= 1;
                    end
                end
                
                RIGHT: begin
                    if (~ground) begin
                        state <= FALL;
                    end else if (bump_right_edge) begin
                        state <= LEFT;
                        direction <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= direction ? RIGHT : LEFT;
                    end
                end
            endcase
        end
    end
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL);

endmodule