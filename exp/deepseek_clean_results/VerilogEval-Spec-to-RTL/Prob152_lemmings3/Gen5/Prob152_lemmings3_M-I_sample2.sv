module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding with direction embedded
    // [2:1] - state (Gray coded)
    // [0]   - direction (only valid in WALK state)
    parameter WALK_L = 3'b000; // Gray 0
    parameter WALK_R = 3'b001; // Gray 1
    parameter FALL   = 3'b011; // Gray 3
    parameter DIG_L  = 3'b010; // Gray 2
    parameter DIG_R  = 3'b110; // Gray 6

    reg [2:0] state, next_state;

    // State transition logic (optimized parallel evaluation)
    always @(*) begin
        next_state = state;
        
        case (state[2:1])
            2'b00, 2'b01: begin // WALK states (L/R)
                if (!ground) begin
                    next_state = FALL;
                end
                else if (dig) begin
                    next_state = state[0] ? DIG_R : DIG_L;
                end
                else if ((bump_left && !state[0]) || (bump_right && state[0])) begin
                    next_state[0] = ~state[0]; // Toggle direction
                end
            end
            
            2'b11: begin // FALL
                if (ground) begin
                    next_state = state[0] ? WALK_R : WALK_L;
                end
            end
            
            2'b10: begin // DIG states (L/R)
                if (!ground) begin
                    next_state = FALL;
                end
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end
        else begin
            state <= next_state;
        end
    end

    // Registered outputs to reduce glitching
    always @(posedge clk) begin
        case (state[2:1])
            2'b00, 2'b01: begin // WALK
                walk_left <= ~state[0];
                walk_right <= state[0];
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            2'b11: begin // FALL
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            2'b10: begin // DIG
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
        endcase
    end

endmodule