module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] STATE;  // 2-bit state register
reg [1:0] NEXT_STATE;  // next state

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;

// Sequential logic: update STATE register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        STATE <= WALK_LEFT;
    end else begin
        STATE <= NEXT_STATE;
    end
end

// Combinational logic: generate next state and outputs
always @(*) begin
    case (STATE)
        WALK_LEFT: begin
            if (bump_left) begin
                NEXT_STATE <= WALK_RIGHT;
            end else if (bump_right) begin
                NEXT_STATE <= WALK_LEFT;  // already walking left
            end else if (!ground) begin
                NEXT_STATE <= FALL;
            end else begin
                NEXT_STATE <= WALK_LEFT;
            end
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
        WALK_RIGHT: begin
            if (bump_left) begin
                NEXT_STATE <= WALK_LEFT;
            end else if (bump_right) begin
                NEXT_STATE <= WALK_LEFT;
            end else if (!ground) begin
                NEXT_STATE <= FALL;
            end else begin
                NEXT_STATE <= WALK_RIGHT;
            end
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
        end
        FALL: begin
            if (ground) begin
                // resume walking in the same direction as before the fall
                if (bump_left || bump_right) begin
                    // ignore bump inputs while falling or when ground reappears
                    if (STATE == WALK_LEFT) begin
                        NEXT_STATE <= WALK_LEFT;
                    end else begin
                        NEXT_STATE <= WALK_RIGHT;
                    end
                end else if (STATE == WALK_LEFT) begin
                    NEXT_STATE <= WALK_LEFT;
                end else begin
                    NEXT_STATE <= WALK_RIGHT;
                end
            end else begin
                NEXT_STATE <= FALL;
            end
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
        end
        default: begin
            NEXT_STATE <= WALK_LEFT;
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
        end
    endcase
end

endmodule