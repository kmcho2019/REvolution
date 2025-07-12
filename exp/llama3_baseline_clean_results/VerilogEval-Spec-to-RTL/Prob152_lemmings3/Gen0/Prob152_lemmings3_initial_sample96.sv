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

// Define the states of the machine
parameter IDLE_LEFT = 2'b00;
parameter IDLE_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state;
reg [1:0] state_next;
reg direction;

// Sequential logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE_LEFT;
        direction <= 0;
    end else begin
        state <= state_next;
    end
end

// Combinational logic
always @ (*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        IDLE_LEFT: begin
            walk_left = 1'b1;
            if (!ground) begin
                state_next = FALLING;
            end else if (dig) begin
                state_next = DIGGING;
            end else if (bump_left) begin
                state_next = IDLE_RIGHT;
            end else if (bump_right) begin
                state_next = IDLE_LEFT;
            end else begin
                state_next = IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            walk_right = 1'b1;
            if (!ground) begin
                state_next = FALLING;
            end else if (dig) begin
                state_next = DIGGING;
            end else if (bump_left) begin
                state_next = IDLE_LEFT;
            end else if (bump_right) begin
                state_next = IDLE_RIGHT;
            end else begin
                state_next = IDLE_RIGHT;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (direction) begin
                    state_next = IDLE_RIGHT;
                end else begin
                    state_next = IDLE_LEFT;
                end
            end else begin
                state_next = FALLING;
            end
        end
        DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                state_next = FALLING;
                if (direction) begin
                    direction <= 0;
                end else begin
                    direction <= 1;
                end
            end else begin
                state_next = DIGGING;
            end
        end
        default: begin
            state_next = IDLE_LEFT;
        end
    endcase
    
    if (state == IDLE_LEFT) begin
        direction <= 0;
    end else if (state == IDLE_RIGHT) begin
        direction <= 1;
    end
end

endmodule