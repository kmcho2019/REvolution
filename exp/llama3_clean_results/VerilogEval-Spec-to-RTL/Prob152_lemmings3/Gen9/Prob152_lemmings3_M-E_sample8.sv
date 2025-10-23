module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states
`define STATE_WALK 2'b00
`define STATE_FALL 2'b01
`define STATE_DIG 2'b10

// Define direction
`define DIR_LEFT 1'b0
`define DIR_RIGHT 1'b1

// Define input encoding
`define INPUT_BUMP_LEFT 2'b01
`define INPUT_BUMP_RIGHT 2'b10
`define INPUT_GROUND 2'b00
`define INPUT_DIG 2'b11

reg [1:0] state;
reg direction;
reg [1:0] input_encoded;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `STATE_WALK;
        direction <= `DIR_LEFT;
    end else begin
        // Input encoding
        if (bump_left) begin
            input_encoded <= `INPUT_BUMP_LEFT;
        end else if (bump_right) begin
            input_encoded <= `INPUT_BUMP_RIGHT;
        end else if (ground && dig) begin
            input_encoded <= `INPUT_DIG;
        end else begin
            input_encoded <= `INPUT_GROUND;
        end

        // State transition logic
        case (state)
            `STATE_WALK: begin
                if (input_encoded == `INPUT_BUMP_LEFT) begin
                    direction <= `DIR_RIGHT;
                end else if (input_encoded == `INPUT_BUMP_RIGHT) begin
                    direction <= `DIR_LEFT;
                end else if (input_encoded == `INPUT_DIG) begin
                    state <= `STATE_DIG;
                end else if (!ground) begin
                    state <= `STATE_FALL;
                end
            end
            `STATE_FALL: begin
                if (ground) begin
                    state <= `STATE_WALK;
                end
            end
            `STATE_DIG: begin
                if (!ground) begin
                    state <= `STATE_FALL;
                end
            end
        endcase
    end
end

// Output assignment
always @(*) begin
    case (state)
        `STATE_WALK: begin
            walk_left = (direction == `DIR_LEFT);
            walk_right = (direction == `DIR_RIGHT);
            aaah = 1'b0;
            digging = 1'b0;
        end
        `STATE_FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
        end
        `STATE_DIG: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
        end
    endcase
end

endmodule