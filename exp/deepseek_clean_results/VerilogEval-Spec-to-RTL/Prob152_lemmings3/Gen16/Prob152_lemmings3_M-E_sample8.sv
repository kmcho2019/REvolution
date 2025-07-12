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

    // States
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;

    reg [1:0] state;
    reg direction; // 0=left, 1=right
    reg ground_prev;

    // Falling edge detection
    wire ground_falling_edge = ground_prev & ~ground;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            ground_prev <= 1;
        end else begin
            ground_prev <= ground;
            
            case (state)
                WALK: begin
                    if (ground_falling_edge) begin
                        state <= FALL;
                    end else if (dig & ground) begin
                        state <= DIG;
                    end else if (!ground_falling_edge) begin
                        if (bump_left) direction <= 1;
                        else if (bump_right) direction <= 0;
                    end
                end
                
                FALL: begin
                    if (ground) state <= WALK;
                end
                
                DIG: begin
                    if (!ground) state <= FALL;
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction;
    assign walk_right = (state == WALK) & direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule