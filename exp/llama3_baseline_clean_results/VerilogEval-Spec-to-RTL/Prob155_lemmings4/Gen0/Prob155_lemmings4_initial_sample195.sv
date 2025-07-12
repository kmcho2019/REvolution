module TopModule (
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

// Define the states
localparam IDLE_LEFT = 0;
localparam IDLE_RIGHT = 1;
localparam FALLING = 2;
localparam DIGGING = 3;
localparam SPLATTERED = 4;

// Define the registers
reg [2:0] state;
reg [2:0] nextState;
reg [4:0] fall_count;
reg prev_walk_left;

// Initialize the state machine
initial begin
    state = IDLE_LEFT;
    fall_count = 0;
    prev_walk_left = 1;
end

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        fall_count <= 0;
        prev_walk_left <= 1;
    end else begin
        state <= nextState;
        if (nextState == FALLING) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    // Default values
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    // Determine the next state and outputs
    case (state)
        IDLE_LEFT: begin
            walk_left = 1;
            if (bump_left) begin
                nextState = IDLE_RIGHT;
                prev_walk_left <= 0;
            end else if (bump_right) begin
                nextState = IDLE_LEFT;
            end else if (!ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else begin
                nextState = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1;
            if (bump_right) begin
                nextState = IDLE_LEFT;
                prev_walk_left <= 1;
            end else if (bump_left) begin
                nextState = IDLE_RIGHT;
            end else if (!ground) begin
                nextState = FALLING;
            end else if (dig) begin
                nextState = DIGGING;
            end else begin
                nextState = IDLE_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1;
            if (ground) begin
                if (fall_count > 20) begin
                    nextState = SPLATTERED;
                end else if (prev_walk_left) begin
                    nextState = IDLE_LEFT;
                end else begin
                    nextState = IDLE_RIGHT;
                end
            end else begin
                nextState = FALLING;
            end
        end
        DIGGING: begin
            digging = 1;
            if (!ground) begin
                nextState = FALLING;
            end else begin
                nextState = DIGGING;
            end
        end
        SPLATTERED: begin
            nextState = SPLATTERED;
        end
    endcase
end

endmodule