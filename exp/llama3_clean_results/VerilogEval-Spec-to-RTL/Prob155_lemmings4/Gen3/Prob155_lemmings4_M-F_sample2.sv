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
    walking_left,
    walking_right,
    falling,
    digging_state,
    splattered
} state;

// Define variables to store original direction and counter for falling
logic original_direction;
logic [4:0] fall_counter;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
        fall_counter <= 0;
        original_direction <= 1'b1;
    end else begin
        case (state)
            walking_left: begin
                if (~ground) begin
                    state <= falling;
                    original_direction <= 1'b1; // walking left
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= digging_state;
                    original_direction <= 1'b1; // walking left
                end else if (bump_right) begin
                    state <= walking_right;
                end
            end
            walking_right: begin
                if (~ground) begin
                    state <= falling;
                    original_direction <= 1'b0; // walking right
                    fall_counter <= 1;
                end else if (dig) begin
                    state <= digging_state;
                    original_direction <= 1'b0; // walking right
                end else if (bump_left) begin
                    state <= walking_left;
                end
            end
            falling: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        state <= splattered;
                    end else if (original_direction) begin
                        state <= walking_left;
                    end else begin
                        state <= walking_right;
                    end
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end
            digging_state: begin
                if (~ground) begin
                    state <= falling;
                    fall_counter <= 1;
                end
            end
            splattered: begin
                // Do nothing
            end
        endcase
    end
end

// Combinational logic
assign walk_left = (state == walking_left) || (state == digging_state && original_direction);
assign walk_right = (state == walking_right) || (state == digging_state && ~original_direction);
assign aaah = state == falling;
assign digging = state == digging_state;

endmodule