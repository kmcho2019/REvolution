module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

// Define an enumeration for the states
typedef enum logic {LEFT = 0, RIGHT = 1} state_t;

reg state; // Using a 1-bit state variable

// Sequential logic for state update and output logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT; // Initialize state to LEFT
        walk_left <= 1'b1;
        walk_right <= 1'b0;
    end else begin
        case (state)
            LEFT: begin
                if (bump_left) begin
                    state <= RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else begin
                    state <= LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            RIGHT: begin
                if (bump_right) begin
                    state <= LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else begin
                    state <= RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
        endcase
    end
end

endmodule