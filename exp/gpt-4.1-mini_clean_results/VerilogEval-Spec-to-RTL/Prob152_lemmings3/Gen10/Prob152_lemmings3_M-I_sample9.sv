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

// Determine if bumped (left or right)
wire bumped = bump_left | bump_right;
// Determine next direction when bumped: invert if both bumped, else set based on bump side
wire next_dir = (bump_left & bump_right) ? ~dir :
                bump_left ? 1'b1 : 
                bump_right ? 1'b0 : dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= {MODE_WALK, 1'b0}; // Walk left reset state
    end else begin
        case (mode)
            MODE_WALK: begin
                if (!ground) begin
                    state <= {MODE_FALL, dir};
                end else if (dig) begin
                    state <= {MODE_DIG, dir};
                end else if (bumped) begin
                    state <= {MODE_WALK, next_dir};
                end else begin
                    state <= state; // Maintain state without redundant assignments removed here for clarity
                end
            end
            MODE_FALL: begin
                if (ground) begin
                    state <= {MODE_WALK, dir};
                end // else remain falling, no redundant assignment
            end
            MODE_DIG: begin
                if (!ground) begin
                    state <= {MODE_FALL, dir};
                end // else remain digging
            end
            default: begin
                state <= {MODE_WALK, 1'b0};
            end
        endcase
    end
end

assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule