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

// Define the states and directions
`define WALKING 2'b00
`define FALLING 2'b01
`define DIGGING 2'b10
`define LEFT 1'b0
`define RIGHT 1'b1

// Define the state and direction registers
reg [1:0] state;
reg direction;

// Define the high-level state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= `WALKING;
        direction <= `LEFT;
    end else begin
        case (state)
            `WALKING: begin
                if (!ground) begin
                    state <= `FALLING;
                end else if (dig) begin
                    state <= `DIGGING;
                end
            end
            `FALLING: begin
                if (ground) begin
                    state <= `WALKING;
                end
            end
            `DIGGING: begin
                if (!ground) begin
                    state <= `FALLING;
                end
            end
        endcase
    end
end

// Define the low-level direction controller
always @(posedge clk or posedge areset) begin
    if (areset) begin
        direction <= `LEFT;
    end else begin
        case (state)
            `WALKING: begin
                if (bump_left && (direction == `LEFT)) begin
                    direction <= `RIGHT;
                end else if (bump_right && (direction == `RIGHT)) begin
                    direction <= `LEFT;
                end
            end
        endcase
    end
end

// Assign the outputs
assign walk_left = (state == `WALKING && direction == `LEFT);
assign walk_right = (state == `WALKING && direction == `RIGHT);
assign aaah = (state == `FALLING);
assign digging = (state == `DIGGING);

endmodule