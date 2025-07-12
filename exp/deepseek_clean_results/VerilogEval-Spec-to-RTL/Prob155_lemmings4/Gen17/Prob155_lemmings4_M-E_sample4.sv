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

    // Primary states
    parameter WALK = 2'b00;
    parameter DIG  = 2'b01;
    parameter FALL = 2'b10;
    parameter SPLAT = 2'b11;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg [1:0] primary_state;
    reg direction;
    reg [4:0] fall_timer;
    
    // Event signals
    wire fall_event = !ground;
    wire dig_event = dig && ground && (primary_state == WALK);
    wire bump_event = (direction == LEFT && bump_left) || 
                     (direction == RIGHT && bump_right);
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            primary_state <= WALK;
            direction <= LEFT;
            fall_timer <= 0;
        end else begin
            case (primary_state)
                WALK: begin
                    if (fall_event) begin
                        primary_state <= FALL;
                        fall_timer <= 1;
                    end else if (dig_event) begin
                        primary_state <= DIG;
                    end else if (bump_event) begin
                        direction <= ~direction;
                    end
                end
                
                DIG: begin
                    if (fall_event) begin
                        primary_state <= FALL;
                        fall_timer <= 1;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_timer > 20) begin
                            primary_state <= SPLAT;
                        end else begin
                            primary_state <= WALK;
                        end
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in splat state forever
                    primary_state <= SPLAT;
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (primary_state == WALK) && (direction == LEFT);
    assign walk_right = (primary_state == WALK) && (direction == RIGHT);
    assign aaah = (primary_state == FALL);
    assign digging = (primary_state == DIG);

endmodule