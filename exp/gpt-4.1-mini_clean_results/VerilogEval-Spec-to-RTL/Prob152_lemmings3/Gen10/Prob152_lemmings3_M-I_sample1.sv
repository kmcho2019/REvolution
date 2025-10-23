module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// State mode encoding (2 bits)
localparam MODE_WALK = 2'b00;
localparam MODE_FALL = 2'b01;
localparam MODE_DIG  = 2'b10;

// State bits:
// bit 2: direction (0=left,1=right)
// bits 1-0: mode

reg [2:0] state, next_state;

wire dir = state[2];
wire [1:0] mode = state[1:0];

// Detect falling edge of ground (ground goes 1->0) using state mode
// Falling occurs when in walking or digging mode and ground deasserts
wire ground_falling_edge = (mode != MODE_FALL) && (ground == 1'b0);

// ground stable is simply ground=1; no need for prev_ground since we removed it

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to walking left on ground
        state <= {1'b0, MODE_WALK};
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state; // default hold
    
    case (mode)
        MODE_WALK: begin
            if (ground_falling_edge) begin
                // Start falling same direction when ground disappears
                next_state = {dir, MODE_FALL};
            end else if (dig && ground) begin
                // Start digging if requested and on ground
                next_state = {dir, MODE_DIG};
            end else if (ground && (bump_left || bump_right)) begin
                // bump_left or bump_right flips walking direction
                // bump_left bump_right together or either side flips direction
                next_state = {~dir, MODE_WALK};
            end
        end
        
        MODE_FALL: begin
            // Stay falling until ground reappears
            if (ground) begin
                next_state = {dir, MODE_WALK};
            end
        end
        
        MODE_DIG: begin
            // Dig while ground, else fall
            if (!ground) begin
                next_state = {dir, MODE_FALL};
            end
        end
        
        default: begin
            // Default fallback to walk left
            next_state = {1'b0, MODE_WALK};
        end
    endcase
end

// Moore outputs: depend only on current state
assign walk_left  = (mode == MODE_WALK) && (dir == 1'b0);
assign walk_right = (mode == MODE_WALK) && (dir == 1'b1);
assign aaah       = (mode == MODE_FALL);
assign digging    = (mode == MODE_DIG);

endmodule