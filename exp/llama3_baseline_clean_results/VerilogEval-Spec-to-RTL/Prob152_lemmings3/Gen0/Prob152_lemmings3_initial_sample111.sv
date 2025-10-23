module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

// Define states
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

// Current state register
reg [1:0] state_reg;
reg [1:0] state_next;

// Output logic
assign walk_left = (state_reg == IDLE_LEFT);
assign walk_right = (state_reg == IDLE_RIGHT);
assign aaah = (state_reg == FALLING);
assign digging = (state_reg == DIGGING);

// Next state logic
always @(*) begin
    case(state_reg)
        IDLE_LEFT: begin
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
            if (!ground) begin
                state_next = FALLING;
            end else if (dig) begin
                state_next = DIGGING;
            end else if (bump_left) begin
                state_next = IDLE_LEFT;
            end else if (bump_right) begin
                state_next = IDLE_LEFT;
            end else begin
                state_next = IDLE_RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                // Maintain previous direction
                if (bump_left) begin
                    state_next = IDLE_RIGHT;
                end else if (bump_right) begin
                    state_next = IDLE_LEFT;
                end else if (state_reg == IDLE_LEFT) begin
                    state_next = IDLE_LEFT;
                end else if (state_reg == IDLE_RIGHT) begin
                    state_next = IDLE_RIGHT;
                end else begin
                    state_next = IDLE_LEFT;
                end
            end else begin
                state_next = FALLING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                state_next = FALLING;
            end else begin
                state_next = DIGGING;
            end
        end
        default: state_next = IDLE_LEFT;
    endcase
end

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= IDLE_LEFT;
    end else begin
        state_reg <= state_next;
    end
end

endmodule