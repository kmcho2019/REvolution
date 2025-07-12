module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states using a binary encoding
reg [1:0] state;
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALL_LEFT = 2'b10;
localparam FALL_RIGHT = 2'b11;

// Control unit to determine the next state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        case(state)
            WALK_LEFT: begin
                if (~ground) begin
                    state <= FALL_LEFT;
                end else if (bump_left) begin
                    state <= WALK_RIGHT;
                end else if (bump_right) begin
                    state <= WALK_LEFT;
                end else if (bump_left && bump_right) begin
                    state <= WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    state <= FALL_RIGHT;
                end else if (bump_left) begin
                    state <= WALK_LEFT;
                end else if (bump_right) begin
                    state <= WALK_RIGHT;
                end else if (bump_left && bump_right) begin
                    state <= WALK_LEFT;
                end
            end
            FALL_LEFT: begin
                if (ground) begin
                    state <= WALK_LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    state <= WALK_RIGHT;
                end
            end
            default: begin
                state <= WALK_LEFT;
            end
        endcase
    end
end

// Output generator to produce the output signals
assign walk_left = (state == WALK_LEFT);
assign walk_right = (state == WALK_RIGHT);
assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);

endmodule