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

// State definitions
parameter WALK_LEFT = 3'b001;
parameter WALK_RIGHT = 3'b010;
parameter FALLING = 3'b011;
parameter DIGGING = 3'b100;
parameter SPLATTERED = 3'b111;

// Internal state variable
reg [2:0] state;
reg [2:0] next_state;

// Internal direction variable (1 for left, 0 for right)
reg direction;

// Internal fall time counter
reg [4:0] fall_time;
reg [4:0] next_fall_time;

// Output variables
reg walk_left_reg;
reg walk_right_reg;
reg aaah_reg;
reg digging_reg;

// Combinational logic to determine next state
always @(*) begin
    next_state = state;
    next_fall_time = fall_time;
    case(state)
        WALK_LEFT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = WALK_RIGHT;
            end else if(bump_right) begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if(!ground) begin
                next_state = FALLING;
            end else if(dig) begin
                next_state = DIGGING;
            end else if(bump_left) begin
                next_state = WALK_LEFT;
            end else if(bump_right) begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            next_fall_time = fall_time + 1;
            if(ground) begin
                if(fall_time > 20) begin
                    next_state = SPLATTERED;
                end else begin
                    if(direction) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end
            end
        end
        DIGGING: begin
            if(!ground) begin
                next_state = FALLING;
                if(direction) begin
                    direction = 1'b1;
                end else begin
                    direction = 1'b0;
                end
            end
        end
        SPLATTERED: begin
            next_state = SPLATTERED;
        end
    endcase
end

// Sequential logic to update state and outputs
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= WALK_LEFT;
        direction <= 1'b1;
        fall_time <= 5'b0;
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end else begin
        state <= next_state;
        fall_time <= next_fall_time;
        case(state)
            WALK_LEFT: begin
                walk_left_reg <= 1'b1;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b0;
            end
            WALK_RIGHT: begin
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b1;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b0;
            end
            FALLING: begin
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b1;
                digging_reg <= 1'b0;
            end
            DIGGING: begin
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b1;
            end
            SPLATTERED: begin
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b0;
            end
        endcase
    end
end

// Output assignments
assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

endmodule