module TopModule (
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

// Define states
localparam IDLE = 2'b00;
localparam WALKING = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

reg [1:0] state;
reg [0:0] direction;  // 0: left, 1: right

// Initialize state and direction
initial state = IDLE;
initial direction = 0;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        direction <= 0;
    end else begin
        case (state)
            IDLE: begin
                state <= WALKING;
            end
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left && !bump_right) begin
                    direction <= 1;
                end else if (bump_right && !bump_left) begin
                    direction <= 0;
                end else if (bump_left && bump_right) begin
                    direction <= !direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= WALKING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                end
            end
        endcase
    end
end

// Combinational logic
always @(*) begin
    walk_left = (state == WALKING && direction == 0) || (state == IDLE);
    walk_right = (state == WALKING && direction == 1);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

endmodule