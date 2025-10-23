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

// Synchronize asynchronous inputs to avoid metastability and glitches
reg bump_left_r1, bump_left_r2;
reg bump_right_r1, bump_right_r2;
reg dig_r1, dig_r2;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset synchronization registers
        bump_left_r1 <= 1'b0;
        bump_left_r2 <= 1'b0;
        bump_right_r1 <= 1'b0;
        bump_right_r2 <= 1'b0;
        dig_r1 <= 1'b0;
        dig_r2 <= 1'b0;
    end else begin
        bump_left_r1 <= bump_left;
        bump_left_r2 <= bump_left_r1;
        bump_right_r1 <= bump_right;
        bump_right_r2 <= bump_right_r1;
        dig_r1 <= dig;
        dig_r2 <= dig_r1;
    end
end

wire bump_left_sync = bump_left_r2;
wire bump_right_sync = bump_right_r2;
wire dig_sync = dig_r2;

// Update prev_ground only when ground changes, to reduce toggling
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {1'b0, WALKING}; // walking left on reset
        prev_ground <= 1'b1;      // assume starting on ground
    end else begin
        state <= next_state;
        if (ground != prev_ground)
            prev_ground <= ground;
    end
end

wire dir = state[2];         // direction: 0=left,1=right
wire [1:0] st = state[1:0]; // substate

// Precompute conditions to reduce combinational fanout and glitches
wire fall_condition = (ground == 1'b0);
wire stable_ground = (ground == 1'b1) && (prev_ground == 1'b1);
wire start_dig = dig_sync && stable_ground;
wire bump_condition = bump_left_sync || bump_right_sync;

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (st)
        WALKING: begin
            // Priority: fall > dig > bump

            if (fall_condition) begin
                next_state = {dir, FALLING};
            end
            else if (start_dig) begin
                next_state = {dir, DIGGING};
            end
            else if (stable_ground && bump_condition) begin
                if (bump_left_sync && bump_right_sync) begin
                    // Both bumps: toggle direction
                    next_state = {~dir, WALKING};
                end
                else if (bump_left_sync) begin
                    // Only bump_left: walk right
                    next_state = {1'b1, WALKING};
                end
                else begin
                    // Only bump_right: walk left
                    next_state = {1'b0, WALKING};
                end
            end
            else begin
                next_state = state; // no change
            end
        end

        FALLING: begin
            if (ground == 1'b1) begin
                next_state = {dir, WALKING};
            end else begin
                next_state = state;
            end
        end

        DIGGING: begin
            if (ground == 1'b0) begin
                next_state = {dir, FALLING};
            end else begin
                next_state = state;
            end
        end

        default: begin
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