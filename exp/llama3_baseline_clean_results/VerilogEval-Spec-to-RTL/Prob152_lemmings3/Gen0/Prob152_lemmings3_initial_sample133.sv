module TopModule (
    input  logic clk,
    input  logic areset,
    input  logic bump_left,
    input  logic bump_right,
    input  logic ground,
    input  logic dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

// Define the states
enum logic [1:0] {walking_left, walking_right, falling, digging_state} current_state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= walking_left;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        walking_left: begin
            if (~ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_right || (bump_left && bump_right)) begin
                next_state = walking_right;
            end else if (bump_left) begin
                next_state = walking_right;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (~ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_state;
            end else if (bump_left || (bump_left && bump_right)) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                if (dig) begin
                    next_state = digging_state;
                end else begin
                    next_state = walking_left; // This might need to be the previous state before falling
                end
            end else begin
                next_state = falling;
            end
        end
        digging_state: begin
            if (~ground) begin
                next_state = falling;
            end else begin
                next_state = digging_state;
            end
        end
        default: next_state = walking_left;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        walking_left: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
        walking_right: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
        end
        falling: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        digging_state: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule