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

localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

reg [2:0] state; // [2:1]=mode, [0]=dir (0=left,1=right)

wire [1:0] mode = state[2:1];
wire dir = state[0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {MODE_WALK, 1'b0}; // Walk left on reset
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    // Falling has highest precedence
                    state <= {MODE_FALL, dir};
                end else if (dig) begin
                    // Digging has next precedence if ground present and walking
                    state <= {MODE_DIG, dir};
                end else if (bump_left || bump_right) begin
                    // Compute new direction:
                    // Flip direction if bumped on both sides or only on the opposite side
                    // Logic: new_dir = (bumped_left XOR bumped_right) ? 
                    //          (if bumped_left) 1 (right) else 0 (left)
                    //          else flip dir
                    // Simplify with XOR and mux:
                    // If both bumps equal (both 0 or both 1), flip dir
                    // Else new_dir = bump_left
                    wire both_bumped = bump_left & bump_right;
                    wire bumps_diff = bump_left ^ bump_right;
                    wire new_dir;
                    if (bumps_diff) begin
                        new_dir = bump_left ? 1'b1 : 1'b0;
                    end else begin
                        new_dir = ~dir;
                    end
                    state <= {MODE_WALK, new_dir};
                end
                // else remain in walking same state; do not reassign to avoid unnecessary toggling
            end

            MODE_FALL: begin
                if (ground) begin
                    state <= {MODE_WALK, dir}; // resume walking same direction
                end
                // else remain falling, no assignment
            end

            MODE_DIG: begin
                if (!ground) begin
                    state <= {MODE_FALL, dir}; // start falling on no ground
                end
                // else remain digging, no assignment
            end

            default: begin
                state <= {MODE_WALK, 1'b0}; // default safe state
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule