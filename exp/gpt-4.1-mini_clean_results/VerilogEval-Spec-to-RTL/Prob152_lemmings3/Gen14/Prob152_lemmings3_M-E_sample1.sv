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

// State encoding: {mode[1:0], dir}
// mode: 2'b00=walk, 2'b01=fall, 2'b10=dig
// dir: 0=left, 1=right
localparam WALK_L = 3'b000;
localparam WALK_R = 3'b001;
localparam FALL_L = 3'b010;
localparam FALL_R = 3'b011;
localparam DIG_L  = 3'b100;
localparam DIG_R  = 3'b101;

reg [2:0] state, next_state;

always @(*) begin
    next_state = state;
    case(state)
        // Walking states
        WALK_L: begin
            if (!ground)              next_state = FALL_L;
            else if (dig)             next_state = DIG_L;
            else if (bump_left || bump_right) begin
                // On bump, reverse direction
                // If both bump, still reverse
                next_state = WALK_R;
            end
        end
        WALK_R: begin
            if (!ground)              next_state = FALL_R;
            else if (dig)             next_state = DIG_R;
            else if (bump_left || bump_right) begin
                next_state = WALK_L;
            end
        end

        // Falling states
        FALL_L: begin
            if (ground)              next_state = WALK_L;
        end
        FALL_R: begin
            if (ground)              next_state = WALK_R;
        end

        // Digging states
        DIG_L: begin
            if (!ground)             next_state = FALL_L;
            // else remain digging
        end
        DIG_R: begin
            if (!ground)             next_state = FALL_R;
            // else remain digging
        end
        default: begin
            next_state = WALK_L; // default safe state
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= WALK_L;
    else
        state <= next_state;
end

// Outputs decode
assign walk_left  = (state == WALK_L);
assign walk_right = (state == WALK_R);
assign aaah       = (state == FALL_L) || (state == FALL_R);
assign digging    = (state == DIG_L)  || (state == DIG_R);

endmodule