module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding: 2 bits
    localparam WALK_LEFT    = 2'b00;
    localparam WALK_RIGHT   = 2'b01;
    localparam FALLING_LEFT  = 2'b10;
    localparam FALLING_RIGHT = 2'b11;

    reg [1:0] state;
    reg ground_d;

    // Edge detection for ground signal
    wire ground_falling = (ground_d == 1'b1) && (ground == 1'b0);
    wire ground_rising  = (ground_d == 1'b0) && (ground == 1'b1);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state    <= WALK_LEFT;
            ground_d <= 1'b1; // Assume ground present at reset
        end else begin
            ground_d <= ground;

            case (state)
                WALK_LEFT: begin
                    // Start falling if ground lost
                    if (ground_falling || (ground == 1'b0)) begin
                        state <= FALLING_LEFT;
                    end
                    // Flip direction if bumped on any side
                    else if (bump_left || bump_right) begin
                        state <= WALK_RIGHT;
                    end
                    // Else remain walking left
                end

                WALK_RIGHT: begin
                    if (ground_falling || (ground == 1'b0)) begin
                        state <= FALLING_RIGHT;
                    end else if (bump_left || bump_right) begin
                        state <= WALK_LEFT;
                    end
                end

                FALLING_LEFT: begin
                    // Resume walking left when ground returns
                    if (ground_rising || (ground == 1'b1)) begin
                        state <= WALK_LEFT;
                    end
                    // Else stay falling left, bumps ignored
                end

                FALLING_RIGHT: begin
                    if (ground_rising || (ground == 1'b1)) begin
                        state <= WALK_RIGHT;
                    end
                end

                default: state <= WALK_LEFT;
            endcase
        end
    end

    // Moore output logic: assign outputs based on state
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end

            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah       = 1'b0;
            end

            FALLING_LEFT, FALLING_RIGHT: begin
                walk_left  = (state == FALLING_LEFT) ? 1'b1 : 1'b0;
                walk_right = (state == FALLING_RIGHT) ? 1'b1 : 1'b0;
                aaah       = 1'b1;
            end

            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
        endcase
    end

endmodule