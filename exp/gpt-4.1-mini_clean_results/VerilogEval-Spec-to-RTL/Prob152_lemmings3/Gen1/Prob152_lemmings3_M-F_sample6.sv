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

// State encoding: 3 bits to include direction in all states
// State bits:
// bit2: direction (0=left, 1=right)
// bits1..0: state type:
//   00 = walking
//   01 = falling (aaah)
//   10 = digging
//   11 = unused (not used)

localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;

reg [2:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // reset to walking left
        state <= {1'b0, WALKING}; // direction=0(left), state=walking
    end else begin
        state <= next_state;
    end
end

// Extract direction and substate from current state
wire dir = state[2];       // 0=left, 1=right
wire [1:0] st = state[1:0]; // 2'b00=walking, 2'b01=falling, 2'b10=digging

// Next state logic
always @(*) begin
    next_state = state; // default hold state

    case (st)
        WALKING: begin
            // Priority: fall > dig > bump
            if (!ground) begin
                // Start falling, keep direction
                next_state = {dir, FALLING};
            end else if (dig) begin
                // Start digging, keep direction
                next_state = {dir, DIGGING};
            end else if (bump_left || bump_right) begin
                // Switch walking direction on bump (either side)
                next_state = {~dir, WALKING};
            end else begin
                // Remain walking same direction
                next_state = state;
            end
        end

        FALLING: begin
            // Falling: remain until ground=1, then resume walking same direction
            if (ground) begin
                next_state = {dir, WALKING};
            end else begin
                next_state = state; // keep falling
            end
        end

        DIGGING: begin
            // Digging: remain digging while ground=1
            // If ground=0, start falling (with same direction)
            if (!ground) begin
                next_state = {dir, FALLING};
            end else begin
                next_state = state;
            end
        end

        default: begin
            // Should not occur, reset to walking left
            next_state = {1'b0, WALKING};
        end
    endcase
end

// Outputs: Moore FSM outputs depend on state only
assign walk_left  = (st == WALKING) && (dir == 1'b0);
assign walk_right = (st == WALKING) && (dir == 1'b1);
assign aaah       = (st == FALLING);
assign digging    = (st == DIGGING);

endmodule