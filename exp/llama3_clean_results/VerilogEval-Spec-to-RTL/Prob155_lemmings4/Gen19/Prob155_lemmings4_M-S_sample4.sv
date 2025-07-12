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

// State machine states
localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam DIGGING = 2'b10;
localparam SPLATTERED = 2'b11;

reg [1:0] state;
reg [1:0] walk_direction;
reg [4:0] fall_counter;
reg digging_on;

// State machine
always @(posedge clk) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 2'b0; // WALKING_LEFT
        fall_counter <= 5'b0;
        digging_on <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                if (dig && ground) begin
                    digging_on <= 1'b1;
                end
                if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
                if (~ground) begin
                    state <= FALLING;
                end else if (digging_on) begin
                    state <= DIGGING;
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
                    fall_counter <= 5'b0;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    state <= FALLING;
                    digging_on <= 1'b0;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

// Combinational logic for outputs
always @(*) begin
    walk_left = (state == WALKING && walk_direction == 2'b0) || (state == DIGGING && walk_direction == 2'b0);
    walk_right = (state == WALKING && walk_direction == 2'b1) || (state == DIGGING && walk_direction == 2'b1);
    aaah = (state == FALLING);
    digging = (state == DIGGING);
end

endmodule