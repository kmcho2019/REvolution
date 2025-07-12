module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] current_state;
reg [0:0] next_state;

// State definitions
localparam WALK_LEFT = 1'b0;
localparam WALK_RIGHT = 1'b1;

// Combinational logic for next state
always @(*)
begin
    case(current_state)
        WALK_LEFT:
            if (bump_left)
                next_state = WALK_RIGHT;
            else
                next_state = WALK_LEFT;
        WALK_RIGHT:
            if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_RIGHT;
        default:
            next_state = WALK_LEFT;
    endcase
    
    if (bump_left && bump_right)
    begin
        case(current_state)
            WALK_LEFT:
                next_state = WALK_RIGHT;
            WALK_RIGHT:
                next_state = WALK_LEFT;
            default:
                next_state = WALK_LEFT;
        endcase
    end
end

// Sequential logic for state register
always @(posedge clk or posedge areset)
begin
    if (areset)
        current_state <= WALK_LEFT;
    else
        current_state <= next_state;
end

// Output logic
always @(*)
begin
    case(current_state)
        WALK_LEFT:
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        WALK_RIGHT:
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
        default:
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
    endcase
end

endmodule