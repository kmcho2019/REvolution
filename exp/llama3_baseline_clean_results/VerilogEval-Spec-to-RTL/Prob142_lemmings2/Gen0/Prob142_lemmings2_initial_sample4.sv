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

// Define the states
reg [1:0] state;
reg [1:0] next_state;

// Define the output signals
reg walk_left_out;
reg walk_right_out;
reg aaah_out;

// Define the current direction
reg direction;

// State machine states
parameter WL = 2'b00; // walking left
parameter WR = 2'b01; // walking right
parameter F = 2'b10; // falling

always @(*) begin
    // Defaults
    next_state = state;
    walk_left_out = 1'b0;
    walk_right_out = 1'b0;
    aaah_out = 1'b0;

    // Current state logic
    case (state)
        WL: begin
            walk_left_out = 1'b1;
            if (ground == 1'b0) begin
                next_state = F;
            end else if (bump_left == 1'b1) begin
                next_state = WR;
            end else if (bump_right == 1'b1) begin
                next_state = WR;
            end
        end
        WR: begin
            walk_right_out = 1'b1;
            if (ground == 1'b0) begin
                next_state = F;
            end else if (bump_left == 1'b1) begin
                next_state = WL;
            end else if (bump_right == 1'b1) begin
                next_state = WL;
            end
        end
        F: begin
            aaah_out = 1'b1;
            if (ground == 1'b1) begin
                if (direction == 1'b0) begin
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset == 1'b1) begin
        state <= WL;
        direction <= 1'b0;
    end else begin
        state <= next_state;
        if (state == WL) begin
            direction <= 1'b0;
        end else if (state == WR) begin
            direction <= 1'b1;
        end
    end
end

// Assign output signals
assign walk_left = walk_left_out;
assign walk_right = walk_right_out;
assign aaah = aaah_out;

endmodule