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
    parameter WALK_L = 0;
    parameter WALK_R = 1;
    parameter DIGGING = 2;
    parameter FALLING = 3;
    parameter SPLATTER = 4;
    
    reg [4:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    
    // Output logic
    assign walk_left = (state[WALK_L] && !state[SPLATTER]);
    assign walk_right = (state[WALK_R] && !state[SPLATTER]);
    assign aaah = state[FALLING];
    assign digging = (state[DIGGING] && !state[SPLATTER]);
    
    // Fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_counter <= 0;
        end else if (state[FALLING]) begin
            fall_counter <= ground ? 0 : fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
    end
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= (1 << WALK_L);
            direction <= 0;
        end else begin
            case (1'b1)
                state[SPLATTER]: begin
                    // Stay in splatter state
                    state <= (1 << SPLATTER);
                end
                
                state[FALLING]: begin
                    if (ground) begin
                        if (fall_counter > 20) begin
                            state <= (1 << SPLATTER);
                        end else begin
                            state <= direction ? (1 << WALK_R) : (1 << WALK_L);
                        end
                    end
                end
                
                state[DIGGING]: begin
                    if (!ground) begin
                        state <= (1 << FALLING);
                    end
                end
                
                state[WALK_L] || state[WALK_R]: begin
                    if (!ground) begin
                        state <= (1 << FALLING);
                    end else if (dig) begin
                        state <= (1 << DIGGING);
                    end else if ((state[WALK_L] && bump_left) || 
                                (state[WALK_R] && bump_right)) begin
                        direction <= ~direction;
                        state <= direction ? (1 << WALK_L) : (1 << WALK_R);
                    end
                end
                
                default: begin  // Shouldn't happen
                    state <= (1 << WALK_L);
                    direction <= 0;
                end
            endcase
        end
    end

endmodule