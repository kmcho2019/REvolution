module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    output reg      walk_left,
    output reg      walk_right,
    output reg      aaah
);

// Define the states
reg [1:0] state;
localparam IDLE_LEFT = 2'b00; // walking left
localparam IDLE_RIGHT = 2'b01; // walking right
localparam FALL_LEFT = 2'b10; // falling after walking left
localparam FALL_RIGHT = 2'b11; // falling after walking right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                if (ground == 1'b0) begin
                    state <= FALL_LEFT;
                end else if (bump_left == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                    state <= IDLE_RIGHT;
                end else if (bump_right == 1'b1) begin
                    state <= IDLE_LEFT;
                end else begin
                    state <= IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                if (ground == 1'b0) begin
                    state <= FALL_RIGHT;
                end else if (bump_right == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                    state <= IDLE_LEFT;
                end else if (bump_left == 1'b1) begin
                    state <= IDLE_RIGHT;
                end else begin
                    state <= IDLE_RIGHT;
                end
            end
            FALL_LEFT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground == 1'b1) begin
                    state <= IDLE_LEFT;
                end else begin
                    state <= FALL_LEFT;
                end
            end
            FALL_RIGHT: begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground == 1'b1) begin
                    state <= IDLE_RIGHT;
                end else begin
                    state <= FALL_RIGHT;
                end
            end
            default: begin
                state <= IDLE_LEFT;
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
            end
        endcase
    end
end

endmodule