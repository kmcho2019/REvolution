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

// State encoding (3 bits):
// bit2: direction (0=left, 1=right)
// bits1..0: state type:
//   00 = walking
//   01 = falling (aaah)
//   10 = digging
//   11 = unused

localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;

reg [2:0] state, next_state;

// Register to hold previous ground value for edge detection
reg prev_ground;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {1'b0, WALKING}; // walking left on reset
        prev_ground <= 1'b1;      // assume starting on ground
    end else begin
        state <= next_state;
        prev_ground <= ground;
    end
end

wire dir = state[2];       // direction: 0=left,1=right
wire [1:0] st = state[1:0];// substate

// Condition: stable walking on ground means ground=1 and prev_ground=1
wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (st)
        WALKING: begin
            // Priority: fall > dig > bump

            // Falling if ground is currently 0 (falling starts immediately when ground disappears)
            if (ground == 1'b0) begin
                next_state = {dir, FALLING};
            end
            // Dig if dig=1 and stable walking on ground (falling has priority, so here ground=1)
            else if (dig == 1'b1 && stable_ground) begin
                next_state = {dir, DIGGING};
            end
            // Switch direction on bump only if stable walking on ground
            else if (stable_ground && (bump_left || bump_right)) begin
                next_state = {~dir, WALKING};
            end
            else begin
                next_state = state; // remain walking same direction
            end
        end

        FALLING: begin
            // Remain falling until ground=1, then resume walking same direction
            if (ground == 1'b1) begin
                next_state = {dir, WALKING};
            end else begin
                next_state = state;
            end
        end

        DIGGING: begin
            // Remain digging while ground=1, else start falling
            if (ground == 1'b0) begin
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

// Outputs depend only on state (Moore FSM)
assign walk_left  = (st == WALKING) && (dir == 1'b0);
assign walk_right = (st == WALKING) && (dir == 1'b1);
assign aaah       = (st == FALLING);
assign digging    = (st == DIGGING);

endmodule