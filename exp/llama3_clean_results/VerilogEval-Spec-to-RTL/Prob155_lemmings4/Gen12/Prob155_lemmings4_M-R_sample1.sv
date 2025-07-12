module TopModule(
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

// Define the states
enum logic [1:0] {
    WALKING = 2'b00,
    FALLING = 2'b01,
    DIGGING = 2'b10,
    SPLATTERED = 2'b11
} state, next_state;

// Define the walking direction
reg walking_left_dir;

// Define the fall counter
reg [4:0] fall_counter;

// Define the splattered signal
reg splattered;

// Update the state and outputs
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walking_left_dir <= 1'b1;
        fall_counter <= 5'b0;
        splattered <= 1'b0;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left) begin
                    walking_left_dir <= 1'b0;
                end else if (bump_right) begin
                    walking_left_dir <= 1'b1;
                end
                walk_left <= walking_left_dir;
                walk_right <= ~walking_left_dir;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                        splattered <= 1'b1;
                    end else begin
                        state <= WALKING;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                end
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                digging <= 1'b0;
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_counter <= 5'b1;
                end else if (!dig) begin
                    state <= WALKING;
                end
                walk_left <= walking_left_dir;
                walk_right <= ~walking_left_dir;
                aaah <= 1'b0;
                digging <= 1'b1;
            end
            SPLATTERED: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule