module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the states
reg [1:0] state;
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        WALK_LEFT: 
            if (bump_left) begin
                walk_left = 0;
                walk_right = 1;
            end else begin
                walk_left = 1;
                walk_right = 0;
            end
        WALK_RIGHT: 
            if (bump_right) begin
                walk_left = 1;
                walk_right = 0;
            end else begin
                walk_left = 0;
                walk_right = 1;
            end
        default: begin
            walk_left = 1;
            walk_right = 0;
        end
    endcase
end

// Sequential logic to update the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case(state)
            WALK_LEFT: 
                if (bump_left) begin
                    state <= WALK_RIGHT;
                end
            WALK_RIGHT: 
                if (bump_right) begin
                    state <= WALK_LEFT;
                end
            default: begin
                state <= WALK_LEFT;
            end
        endcase
    end
end

// Set the initial state
initial begin
    state = WALK_LEFT;
end