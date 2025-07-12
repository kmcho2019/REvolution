module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // States
    localparam LEFT  = 2'b00;
    localparam RIGHT = 2'b01;
    localparam FALL  = 2'b10;

    reg [1:0] state, next_state;

    // Direction register: 0 = left, 1 = right
    reg dir, next_dir;

    // Register ground to detect edges
    reg ground_d;

    // Update ground_d to detect edges
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ground_d <= 1'b1;
        end else begin
            ground_d <= ground;
        end
    end

    // FSM sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            dir <= 1'b0; // left
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Combinational logic
    always @(*) begin
        next_state = state;
        next_dir = dir;

        // Detect ground edges
        wire ground_fell = (ground_d == 1'b1) && (ground == 1'b0);
        wire ground_rose = (ground_d == 1'b0) && (ground == 1'b1);

        case (state)
            LEFT: begin
                // If ground lost, enter FALL state
                if (ground_fell) begin
                    next_state = FALL;
                    next_dir = dir; // keep direction
                end else begin
                    // walking left on ground
                    // bump on left or right switches direction
                    if (bump_left || bump_right) begin
                        next_state = RIGHT;
                        next_dir = 1'b1; // right
                    end else begin
                        next_state = LEFT;
                        next_dir = 1'b0; // left
                    end
                end
            end
            RIGHT: begin
                if (ground_fell) begin
                    next_state = FALL;
                    next_dir = dir; // keep direction
                end else begin
                    if (bump_left || bump_right) begin
                        next_state = LEFT;
                        next_dir = 1'b0; // left
                    end else begin
                        next_state = RIGHT;
                        next_dir = 1'b1; // right
                    end
                end
            end
            FALL: begin
                // falling state: bumps ignored
                // wait for ground to reappear
                if (ground_rose) begin
                    // ground back, resume walking
                    if (dir == 1'b0)
                        next_state = LEFT;
                    else
                        next_state = RIGHT;
                    // dir unchanged
                end else begin
                    // stay in fall
                    next_state = FALL;
                    next_dir = dir; // keep direction
                end
            end
            default: begin
                next_state = LEFT;
                next_dir = 1'b0;
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        case (state)
            LEFT:  walk_left  = 1'b1;
            RIGHT: walk_right = 1'b1;
            FALL:  aaah       = 1'b1;
        endcase
    end

endmodule