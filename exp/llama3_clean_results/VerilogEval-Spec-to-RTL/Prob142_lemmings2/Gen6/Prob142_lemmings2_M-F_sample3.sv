module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// State encoding: 2'b00 - walking left, 2'b01 - walking right, 2'b10 - falling left, 2'b11 - falling right
reg [1:0] state;
reg [1:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;
    
    case(state)
        2'b00: // walking left
            begin
                if (~ground) next_state = 2'b10; // start falling left
                else if (bump_left) next_state = 2'b01; // switch to walking right
            end
        2'b01: // walking right
            begin
                if (~ground) next_state = 2'b11; // start falling right
                else if (bump_right) next_state = 2'b00; // switch to walking left
            end
        2'b10, 2'b11: // falling
            begin
                if (ground) // ground reappeared
                    begin
                        // Resume walking in the same direction as before the fall
                        if (state == 2'b10) next_state = 2'b00; // resume walking left
                        else next_state = 2'b01; // resume walking right
                    end
            end
    endcase
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        2'b00: // walking left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        2'b01: // walking right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
        2'b10, 2'b11: // falling
            begin
                // During falling, maintain the last walking direction
                if (state == 2'b10) begin
                    walk_left = 1'b1;
                    walk_right = 1'b0;
                end else begin
                    walk_left = 1'b0;
                    walk_right = 1'b1;
                end
            end
    endcase
    
    // Determine aaah based on state
    aaah = (state == 2'b10 || state == 2'b11)? 1'b1 : 1'b0;
end

endmodule