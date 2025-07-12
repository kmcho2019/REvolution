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

    // State encoding
    parameter WALK_L = 2'b00;
    parameter WALK_R = 2'b01;
    parameter DIGGING = 2'b10;
    parameter FALLING = 2'b11;
    parameter SPLATTER = 3'b100;  // Extra bit for splatter state
    
    reg [2:0] state;
    reg direction;  // 0 for left, 1 for right
    reg [4:0] fall_counter;
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
            fall_counter <= 0;
        end else begin
            // Fall counter logic
            if (state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
            
            // State transitions
            case (state)
                WALK_L, WALK_R: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if ((state == WALK_L && bump_left) || 
                                (state == WALK_R && bump_right)) begin
                        direction <= ~direction;
                        state <= direction ? WALK_L : WALK_R;
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= SPLATTER;
                        end else begin
                            state <= direction ? WALK_R : WALK_L;
                        end
                    end
                end
                
                SPLATTER: begin
                    // Stay in splatter state forever
                    state <= SPLATTER;
                end
            endcase
        end
    end

endmodule