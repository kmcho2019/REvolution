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

localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;
localparam SPLATTERED = 2'b11;

reg [1:0] state;
reg [4:0] fall_counter;
reg walking_direction;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= WALKING;
        fall_counter <= 5'b0;
        walking_direction <= 1'b1; // walking left
    end else begin
        case (state)
            WALKING: begin
                if (~ground) begin
                    state <= FALLING;
                    walking_direction <= walking_direction; // preserve direction
                end else if (dig) begin
                    state <= DIGGING;
                end else if (bump_left || bump_right) begin
                    walking_direction <= ~walking_direction;
                end
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                    end
                    fall_counter <= 5'b0; // reset counter
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                end else if (~dig) begin
                    state <= WALKING;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

always @(*) begin
    case (state)
        WALKING: begin
            walk_left = walking_direction;
            walk_right = ~walking_direction;
            aaah = 1'b0;
            digging = 1'b0;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        DIGGING: begin
            walk_left = walking_direction;
            walk_right = ~walking_direction;
            aaah = 1'b0;
            digging = 1'b1;
        end
        SPLATTERED: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
        end
    endcase
end

endmodule