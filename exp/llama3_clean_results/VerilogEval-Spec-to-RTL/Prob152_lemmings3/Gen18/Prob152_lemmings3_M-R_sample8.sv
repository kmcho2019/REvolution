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

parameter IDLE = 2'b00;
parameter FALLING = 2'b01;
parameter DIGGING = 2'b10;

reg [1:0] state;
reg walk_direction;

// Define the next state logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        walk_direction <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (!ground) begin
                    state <= FALLING;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
            end
            FALLING: begin
                if (ground) begin
                    state <= IDLE;
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

// Define the output logic using assign statements
assign walk_left = (state == IDLE && ~walk_direction);
assign walk_right = (state == IDLE && walk_direction);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule