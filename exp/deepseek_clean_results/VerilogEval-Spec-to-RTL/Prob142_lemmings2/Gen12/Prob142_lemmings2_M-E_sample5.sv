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

    // One-hot encoded states
    parameter LEFT = 4'b0001;
    parameter RIGHT = 4'b0010;
    parameter FALL_LEFT = 4'b0100;
    parameter FALL_RIGHT = 4'b1000;
    
    reg [3:0] state;
    reg ground_prev;  // For edge detection
    
    // Edge detection for ground signal
    always @(posedge clk) begin
        ground_prev <= ground;
    end
    
    wire ground_falling = ground_prev && !ground;
    wire ground_rising = !ground_prev && ground;
    
    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
            ground_prev <= 1'b1;
        end
        else begin
            case (state)
                LEFT: begin
                    if (ground_falling) begin
                        state <= FALL_LEFT;
                    end
                    else if (bump_left) begin
                        state <= RIGHT;
                    end
                end
                RIGHT: begin
                    if (ground_falling) begin
                        state <= FALL_RIGHT;
                    end
                    else if (bump_right) begin
                        state <= LEFT;
                    end
                end
                FALL_LEFT: begin
                    if (ground_rising) begin
                        state <= LEFT;
                    end
                end
                FALL_RIGHT: begin
                    if (ground_rising) begin
                        state <= RIGHT;
                    end
                end
            endcase
        end
    end
    
    // Output logic - direct from state bits
    assign walk_left = state[0];  // LEFT state
    assign walk_right = state[1]; // RIGHT state
    assign aaah = state[2] | state[3]; // Either FALL state

endmodule