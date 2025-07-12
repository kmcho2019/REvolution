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

    // One-hot state encoding
    parameter WALK_L = 4'b0001;
    parameter WALK_R = 4'b0010;
    parameter DIGGING = 4'b0100;
    parameter FALLING = 4'b1000;
    
    reg [3:0] state;
    reg [4:0] fall_counter;
    
    // Next state signals
    wire should_fall;
    wire should_dig;
    wire should_switch;
    
    // Priority logic
    assign should_fall = (state == WALK_L || state == WALK_R || state == DIGGING) && !ground;
    assign should_dig = (state == WALK_L || state == WALK_R) && ground && dig && !should_fall;
    assign should_switch = (state == WALK_L && bump_left) || 
                          (state == WALK_R && bump_right) ||
                          ((state == WALK_L || state == WALK_R) && bump_left && bump_right);
    
    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
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
                WALK_L: begin
                    if (should_fall) begin
                        state <= FALLING;
                    end else if (should_dig) begin
                        state <= DIGGING;
                    end else if (should_switch) begin
                        state <= WALK_R;
                    end
                end
                
                WALK_R: begin
                    if (should_fall) begin
                        state <= FALLING;
                    end else if (should_dig) begin
                        state <= DIGGING;
                    end else if (should_switch) begin
                        state <= WALK_L;
                    end
                end
                
                DIGGING: begin
                    if (should_fall) begin
                        state <= FALLING;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= 4'b0000;  // Splatter state (all outputs 0)
                        end else begin
                            // Return to previous direction
                            state <= (state == WALK_R) ? WALK_R : WALK_L;
                        end
                    end
                end
                
                default: begin  // Splatter state
                    state <= 4'b0000;
                end
            endcase
        end
    end

endmodule