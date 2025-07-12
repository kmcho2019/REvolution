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

// Define the modes
enum logic [1:0] { WALKING, FALLING, DIGGING } mode;

// Define the walking direction
enum logic { LEFT, RIGHT } direction;

// Mode register
reg [1:0] mode_reg;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        mode_reg <= WALKING;
    end else begin
        case (mode_reg)
            WALKING: begin
                if (!ground) begin
                    mode_reg <= FALLING;
                end else if (dig) begin
                    mode_reg <= DIGGING;
                end
            end
            FALLING: begin
                if (ground) begin
                    mode_reg <= WALKING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    mode_reg <= FALLING;
                end
            end
        endcase
    end
end

// Walking direction register
reg direction_reg;
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        direction_reg <= LEFT;
    end else if (mode_reg == WALKING) begin
        if (bump_left) begin
            direction_reg <= RIGHT;
        end else if (bump_right) begin
            direction_reg <= LEFT;
        end
    end
end

// Output logic
assign walk_left = (mode_reg == WALKING && direction_reg == LEFT) ? 1'b1 : 1'b0;
assign walk_right = (mode_reg == WALKING && direction_reg == RIGHT) ? 1'b1 : 1'b0;
assign aaah = (mode_reg == FALLING) ? 1'b1 : 1'b0;
assign digging = (mode_reg == DIGGING) ? 1'b1 : 1'b0;

endmodule