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

    // State encoding:
    // [3]   - history bit (1=was digging before fall)
    // [2]   - direction (0=left, 1=right)
    // [1:0] - current state
    parameter WALK_L = 4'b0000;
    parameter WALK_R = 4'b0100;
    parameter FALL   = 4'b0001;
    parameter DIG_L  = 4'b0010;
    parameter DIG_R  = 4'b0110;
    
    reg [3:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end else begin
            case (state[1:0])
                // Walking states
                2'b00: begin
                    if (!ground) begin
                        state <= {1'b0, state[2], 2'b01}; // Fall, keep direction
                    end else if (dig) begin
                        state <= {1'b0, state[2], 2'b10}; // Dig, keep direction
                    end else if (bump_left ^ bump_right) begin
                        // Change direction if bumped on one side
                        state[2] <= bump_left;
                    end else if (bump_left & bump_right) begin
                        // Toggle direction if bumped both sides
                        state[2] <= ~state[2];
                    end
                end
                
                // Digging states
                2'b10: begin
                    if (!ground) begin
                        state <= {1'b1, state[2], 2'b01}; // Fall, remember was digging
                    end
                end
                
                // Falling state
                2'b01: begin
                    if (ground) begin
                        // Recover to previous state (walk or dig)
                        state <= {1'b0, state[2], state[3] ? 2'b10 : 2'b00};
                    end
                end
            endcase
        end
    end

    // Output logic - direct from state bits
    assign walk_left  = (state[1:0] == 2'b00) & ~state[2];
    assign walk_right = (state[1:0] == 2'b00) & state[2];
    assign aaah       = (state[1:0] == 2'b01);
    assign digging    = (state[1:0] == 2'b10);

endmodule