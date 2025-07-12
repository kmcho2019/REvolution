module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
parameter WALKING = 2'b00;
parameter FALLING = 2'b01;
parameter DIGGING = 2'b10;
parameter SPLATTERED = 2'b11;

reg [1:0] state;
reg walk_dir; // 0: left, 1: right
reg [4:0] fall_count;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_dir <= 1'b0; // initial direction: left
        fall_count <= 5'b0;
    end else begin
        case (state)
            WALKING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walk_dir <= ~walk_dir;
                end
            end
            FALLING: begin
                fall_count <= fall_count + 1'b1;
                if (ground) begin
                    if (fall_count > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                    fall_count <= 5'b0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state <= FALLING;
                    fall_count <= 5'b1;
                end
            end
            SPLATTERED: begin
                // stay in this state forever
            end
        endcase
    end
end

always @* begin
    walk_left = (state == WALKING && ~walk_dir && state != SPLATTERED);
    walk_right = (state == WALKING && walk_dir && state != SPLATTERED);
    aaah = (state == FALLING && state != SPLATTERED);
    digging = (state == DIGGING && state != SPLATTERED);
end

endmodule