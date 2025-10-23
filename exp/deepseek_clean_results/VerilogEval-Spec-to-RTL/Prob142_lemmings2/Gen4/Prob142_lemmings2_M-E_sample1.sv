module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // Combined state encoding:
    // bit[1]: 0=walking, 1=falling
    // bit[0]: direction (0=left, 1=right)
    reg [1:0] state, next_state;
    
    // Edge detection for ground signal
    reg ground_prev;
    wire ground_falling_edge = ground_prev && !ground;
    wire ground_rising_edge = !ground_prev && ground;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ground_prev <= 1'b1;
        end else begin
            ground_prev <= ground;
        end
    end
    
    // State transition logic
    always @(*) begin
        case (state[1])
            1'b0: begin // Walking state
                if (ground_falling_edge) begin
                    next_state = {1'b1, state[0]}; // Start falling, keep direction
                end else begin
                    // Priority: left bump over right bump
                    if (bump_left) begin
                        next_state = {1'b0, 1'b1}; // Walk right
                    end else if (bump_right) begin
                        next_state = {1'b0, 1'b0}; // Walk left
                    end else begin
                        next_state = state; // Maintain state
                    end
                end
            end
            1'b1: begin // Falling state
                if (ground_rising_edge) begin
                    next_state = {1'b0, state[0]}; // Resume walking with saved direction
                end else begin
                    next_state = state; // Keep falling
                end
            end
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00; // Walk left
        end else begin
            state <= next_state;
        end
    end
    
    // Registered output logic for glitch-free operation
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end else begin
            walk_left <= ~state[1] && ~state[0]; // Walking left
            walk_right <= ~state[1] && state[0]; // Walking right
            aaah <= state[1]; // Falling
        end
    end

endmodule