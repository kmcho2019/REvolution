module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    // State encoding using localparams
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING    = 2'b10;

    reg [1:0] state, next_state;
    // saved walking direction during falling: 0=left,1=right
    reg saved_dir;

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT;
            saved_dir <= 1'b0;
        end else begin
            state <= next_state;
            // Save walking direction when transitioning to falling
            if (state != FALLING && next_state == FALLING) begin
                saved_dir <= (state == WALK_RIGHT) ? 1'b1 : 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_LEFT;
            end
            FALLING: begin
                if (ground) begin
                    // return to saved walking direction on ground
                    next_state = (saved_dir) ? WALK_RIGHT : WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT; // safety fallback
        endcase
    end

    // Moore output logic
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
        endcase
    end

endmodule