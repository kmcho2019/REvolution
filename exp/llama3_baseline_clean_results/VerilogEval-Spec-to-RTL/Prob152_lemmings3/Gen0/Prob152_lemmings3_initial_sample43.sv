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
localparam IDLE_LEFT = 3'b001;
localparam IDLE_RIGHT = 3'b010;
localparam FALLING = 3'b011;
localparam DIGGING_LEFT = 3'b100;
localparam DIGGING_RIGHT = 3'b101;

// Initialize the current state
reg [2:0] current_state;
reg [2:0] next_state;

// Initialize the output signals
always @(posedge clk or posedge areset) begin
    if(areset) begin
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
        current_state <= IDLE_LEFT;
    end else begin
        current_state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case(current_state)
        IDLE_LEFT: begin
            if(!ground) begin
                next_state <= FALLING;
            end else if(dig) begin
                next_state <= DIGGING_LEFT;
            end else if(bump_left) begin
                next_state <= IDLE_RIGHT;
            end else if(bump_right) begin
                next_state <= IDLE_LEFT;
            end else begin
                next_state <= IDLE_LEFT;
            end
        end
        IDLE_RIGHT: begin
            if(!ground) begin
                next_state <= FALLING;
            end else if(dig) begin
                next_state <= DIGGING_RIGHT;
            end else if(bump_left) begin
                next_state <= IDLE_LEFT;
            end else if(bump_right) begin
                next_state <= IDLE_RIGHT;
            end else begin
                next_state <= IDLE_RIGHT;
            end
        end
        FALLING: begin
            if(ground) begin
                if(current_state == DIGGING_LEFT) begin
                    next_state <= IDLE_LEFT;
                end else if(current_state == DIGGING_RIGHT) begin
                    next_state <= IDLE_RIGHT;
                end else if(current_state == IDLE_LEFT) begin
                    next_state <= IDLE_LEFT;
                end else if(current_state == IDLE_RIGHT) begin
                    next_state <= IDLE_RIGHT;
                end else begin
                    next_state <= IDLE_LEFT;
                end
            end else begin
                next_state <= FALLING;
            end
        end
        DIGGING_LEFT: begin
            if(!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_LEFT;
            end
        end
        DIGGING_RIGHT: begin
            if(!ground) begin
                next_state <= FALLING;
            end else begin
                next_state <= DIGGING_RIGHT;
            end
        end
        default: next_state <= IDLE_LEFT;
    endcase
end

// Assign output signals
always @(*) begin
    case(current_state)
        IDLE_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        IDLE_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
        FALLING: begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            aaah <= 1'b1;
            digging <= 1'b0;
        end
        DIGGING_LEFT: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        DIGGING_RIGHT: begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
            aaah <= 1'b0;
            digging <= 1'b1;
        end
        default: begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            aaah <= 1'b0;
            digging <= 1'b0;
        end
    endcase
end

endmodule