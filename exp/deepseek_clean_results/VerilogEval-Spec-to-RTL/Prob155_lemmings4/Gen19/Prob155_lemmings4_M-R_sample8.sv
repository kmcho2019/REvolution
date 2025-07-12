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

    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    parameter SPLAT = 2'b11;
    
    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_timer;
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
            fall_timer <= 0;
        end else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 1;
                    end else if (dig) begin
                        state <= DIG;
                    end else if ((!direction && bump_left) || 
                                (direction && bump_right) ||
                                (bump_left && bump_right)) begin
                        direction <= !direction;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= WALK;
                        fall_timer <= 0;
                    end else begin
                        fall_timer <= fall_timer + 1;
                    end
                end
                
                DIG: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 1;
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (state == WALK) && !direction && (state != SPLAT);
    assign walk_right = (state == WALK) && direction && (state != SPLAT);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);
    
endmodule