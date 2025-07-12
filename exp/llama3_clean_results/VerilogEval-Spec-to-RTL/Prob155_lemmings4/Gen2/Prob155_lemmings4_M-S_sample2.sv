module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

// Define states
enum logic [2:0] {
    walking,
    falling,
    digging_state,
    splattered
} state, next_state;

// Define variables to store direction and counter for falling
logic direction;
logic [4:0] fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking;
        direction <= 1'b1;
        fall_counter <= 0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        if (state == falling) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 0;
        end
        if (state == walking) begin
            if (direction) begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
            end else begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
            end
        end else begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
        if (state == falling) begin
            aaah <= 1'b1;
        end else begin
            aaah <= 1'b0;
        end
        if (state == digging_state) begin
            digging <= 1'b1;
        end else begin
            digging <= 1'b0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    if (state == walking) begin
        if (~ground) begin
            next_state = falling;
        end else if (dig) begin
            next_state = digging_state;
        end else if (bump_left || bump_right) begin
            direction = ~direction;
        end
    end else if (state == falling) begin
        if (ground) begin
            if (fall_counter > 20) begin
                next_state = splattered;
            end else begin
                next_state = walking;
            end
        end
    end else if (state == digging_state) begin
        if (~ground) begin
            next_state = falling;
        end
    end
end

endmodule