module TopModule (
    input  logic       clk,
    input  logic       areset,
    input  logic       bump_left,
    input  logic       bump_right,
    input  logic       ground,
    input  logic       dig,
    output logic       walk_left,
    output logic       walk_right,
    output logic       aaah,
    output logic       digging
);

// Define states
logic walk_left_state, walk_right_state, falling_state, splattered_state, next_walk_left_state, next_walk_right_state, next_falling_state, next_splattered_state;

// Define a counter for the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter, next_fall_counter;

// Output logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    if (walk_left_state) begin
        walk_left = 1'b1;
        if (dig && ground) digging = 1'b1;
    end
    if (walk_right_state) begin
        walk_right = 1'b1;
        if (dig && ground) digging = 1'b1;
    end
    if (falling_state) begin
        aaah = 1'b1;
    end
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_left_state <= 1'b1;
        walk_right_state <= 1'b0;
        falling_state <= 1'b0;
        splattered_state <= 1'b0;
        fall_counter <= 6'd0;
    end else begin
        walk_left_state <= next_walk_left_state;
        walk_right_state <= next_walk_right_state;
        falling_state <= next_falling_state;
        splattered_state <= next_splattered_state;
        fall_counter <= next_fall_counter;
    end
end

// Combinational logic
always_comb begin
    next_walk_left_state = walk_left_state;
    next_walk_right_state = walk_right_state;
    next_falling_state = falling_state;
    next_splattered_state = splattered_state;
    next_fall_counter = fall_counter;
    
    if (walk_left_state) begin
        if (!ground) begin
            next_walk_left_state = 1'b0;
            next_walk_right_state = 1'b0;
            next_falling_state = 1'b1;
        end else if (bump_left) begin
            next_walk_left_state = 1'b0;
            next_walk_right_state = 1'b1;
        end else if (bump_right) begin
            // No change in state
        end
    end else if (walk_right_state) begin
        if (!ground) begin
            next_walk_left_state = 1'b0;
            next_walk_right_state = 1'b0;
            next_falling_state = 1'b1;
        end else if (bump_right) begin
            next_walk_left_state = 1'b1;
            next_walk_right_state = 1'b0;
        end else if (bump_left) begin
            // No change in state
        end
    end else if (falling_state) begin
        if (ground) begin
            if (fall_counter > 6'd20) begin
                next_falling_state = 1'b0;
                next_splattered_state = 1'b1;
            end else begin
                if (walk_left_state || (walk_right_state && bump_left)) begin
                    next_walk_left_state = 1'b1;
                    next_walk_right_state = 1'b0;
                end else begin
                    next_walk_left_state = 1'b0;
                    next_walk_right_state = 1'b1;
                end
                next_falling_state = 1'b0;
            end
        end else begin
            next_fall_counter = fall_counter + 1'b1;
        end
    end else if (splattered_state) begin
        // No change in state
    end
end

endmodule