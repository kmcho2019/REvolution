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
    parameter SPLATTER = 3'b100;
    
    reg [2:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
    // Fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else if (state == FALLING) begin
            fall_counter <= ground ? 0 : fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
    
    // State and direction transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            direction <= 0;
        end else begin
            case (state)
                SPLATTER: begin
                    // Stay in splatter state forever
                    state <= SPLATTER;
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_counter >= 20) begin
                            state <= SPLATTER;
                        end else begin
                            state <= direction ? WALK_R : WALK_L;
                        end
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                    end
                    // Otherwise stay in DIGGING
                end
                
                WALK_L: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_left) begin
                        direction <= 1;
                        state <= WALK_R;
                    end
                    // Otherwise stay in WALK_L
                end
                
                WALK_R: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_right) begin
                        direction <= 0;
                        state <= WALK_L;
                    end
                    // Otherwise stay in WALK_R
                end
                
                default: begin  // Shouldn't happen
                    state <= WALK_L;
                    direction <= 0;
                end
            endcase
        end
    end

endmodule