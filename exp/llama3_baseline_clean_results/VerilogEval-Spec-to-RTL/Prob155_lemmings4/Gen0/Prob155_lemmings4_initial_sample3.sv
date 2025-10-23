module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    input         dig,
    output        walk_left,
    output        walk_right,
    output        aaah,
    output        digging
);

// Define the states
localparam S_WALK_LEFT = 4'd0;
localparam S_WALK_RIGHT = 4'd1;
localparam S_FALL = 4'd2;
localparam S_DIG = 4'd3;
localparam S_SPLATTER = 4'd4;

// Current state and next state
reg [3:0] state;
reg [3:0] next_state;

// Direction before falling or digging
reg walk_direction;

// Counter for falling duration
reg [5:0] fall_counter;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S_WALK_LEFT;
        walk_direction <= 1'b1; // Walk left initially
        fall_counter <= 6'd0;
    end else begin
        state <= next_state;
        if (state == S_SPLATTER) begin
            fall_counter <= 6'd0;
        end else if (state == S_FALL) begin
            fall_counter <= fall_counter + 1;
        end else begin
            fall_counter <= 6'd0;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        S_WALK_LEFT: begin
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig && ground) begin
                next_state = S_DIG;
            end else if (bump_right) begin
                next_state = S_WALK_RIGHT;
            end else begin
                next_state = S_WALK_LEFT;
            end
        end
        S_WALK_RIGHT: begin
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig && ground) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_LEFT;
            end else begin
                next_state = S_WALK_RIGHT;
            end
        end
        S_FALL: begin
            if (ground) begin
                if (fall_counter > 6'd20) begin
                    next_state = S_SPLATTER;
                end else begin
                    if (walk_direction) begin
                        next_state = S_WALK_LEFT;
                    end else begin
                        next_state = S_WALK_RIGHT;
                    end
                end
            end else begin
                next_state = S_FALL;
            end
        end
        S_DIG: begin
            if (~ground) begin
                next_state = S_FALL;
            end else begin
                next_state = S_DIG;
            end
        end
        S_SPLATTER: begin
            next_state = S_SPLATTER;
        end
        default: begin
            next_state = S_WALK_LEFT;
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S_WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            walk_direction = 1'b1;
        end
        S_WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            walk_direction = 1'b0;
        end
        S_FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        S_DIG: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
        S_SPLATTER: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
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