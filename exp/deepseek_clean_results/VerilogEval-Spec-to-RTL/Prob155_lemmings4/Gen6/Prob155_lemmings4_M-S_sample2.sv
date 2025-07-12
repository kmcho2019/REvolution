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

    parameter LEFT    = 3'b000;
    parameter RIGHT   = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIGGING = 3'b011;
    parameter SPLAT   = 3'b100;
    
    reg [2:0] state;
    reg [4:0] fall_counter;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_counter <= 0;
        end else begin
            case (state)
                LEFT, RIGHT: begin
                    if (~ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else begin
                        // Only change direction if staying in walking state
                        case (state)
                            LEFT:  state <= bump_left ? RIGHT : LEFT;
                            RIGHT: state <= bump_right ? LEFT : RIGHT;
                        endcase
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        state <= (fall_counter > 20) ? SPLAT : (state == LEFT ? LEFT : RIGHT);
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                DIGGING: begin
                    if (~ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALLING);
    assign digging    = (state == DIGGING);

endmodule