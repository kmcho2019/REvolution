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
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLATTERED} state, next_state;

// Define the walking direction
logic walk_dir;

// Define a counter for the number of clock cycles the Lemming has been falling
logic [5:0] fall_counter;

// Output logic
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
            if (walk_dir) begin
                walk_right = 1'b1;
            end else begin
                walk_left = 1'b1;
            end
        end
        default: ;
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_dir <= 1'b0;
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        walk_dir <= (state == WALK_LEFT) ? 1'b0 : (state == WALK_RIGHT) ? 1'b1 : walk_dir;
        if (state == FALLING) begin
            fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    
    case (state)
        WALK_LEFT, WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left ^ bump_right) begin
                next_state = (bump_left) ? WALK_RIGHT : WALK_LEFT;
            end else if (bump_left && bump_right) begin
                next_state = (state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
            end
        end
        FALLING: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = SPLATTERED;
                end else begin
                    next_state = (walk_dir) ? WALK_RIGHT : WALK_LEFT;
                end
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
        SPLATTERED: ;
        default: ;
    endcase
end

endmodule