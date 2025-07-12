module TopModule(
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
localparam WL = 3'd0; // Walking left
localparam WR = 3'd1; // Walking right
localparam FL = 3'd2; // Falling left
localparam FR = 3'd3; // Falling right
localparam DL = 3'd4; // Digging left
localparam DR = 3'd5; // Digging right

reg [2:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL; // Start walking left on reset
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case(state)
        // Walking left
        WL: begin
            if (!ground) begin
                // Fall left
                next_state = FL;
            end else if (dig) begin
                // Start digging left
                next_state = DL;
            end else if (bump_left || bump_right) begin
                // Switch walking direction to right
                next_state = WR;
            end else begin
                next_state = WL;
            end
        end
        // Walking right
        WR: begin
            if (!ground) begin
                // Fall right
                next_state = FR;
            end else if (dig) begin
                // Start digging right
                next_state = DR;
            end else if (bump_left || bump_right) begin
                // Switch walking direction to left
                next_state = WL;
            end else begin
                next_state = WR;
            end
        end
        // Falling left
        FL: begin
            if (ground) begin
                // Resume walking left
                next_state = WL;
            end else begin
                next_state = FL;
            end
        end
        // Falling right
        FR: begin
            if (ground) begin
                // Resume walking right
                next_state = WR;
            end else begin
                next_state = FR;
            end
        end
        // Digging left
        DL: begin
            if (!ground) begin
                // Start falling left
                next_state = FL;
            end else begin
                next_state = DL;
            end
        end
        // Digging right
        DR: begin
            if (!ground) begin
                // Start falling right
                next_state = FR;
            end else begin
                next_state = DR;
            end
        end
        default: next_state = WL; // Safe default
    endcase
end

// Outputs are pure functions of state (Moore machine)
assign walk_left  = (state == WL);
assign walk_right = (state == WR);
assign aaah       = (state == FL) || (state == FR);
assign digging    = (state == DL) || (state == DR);

endmodule