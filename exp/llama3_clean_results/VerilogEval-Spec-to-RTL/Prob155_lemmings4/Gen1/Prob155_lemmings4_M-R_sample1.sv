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

    reg [1:0] state; // current state
    reg [1:0] next_state; // next state
    reg [4:0] fall_count; // fall count

    // Define states
    parameter IDLE_LEFT = 2'b00;
    parameter IDLE_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;
    parameter SPLATTERED = 2'b00; // Changed to avoid overlap with FALLING

    // Output logic using assign
    assign walk_left = (state == IDLE_LEFT);
    assign walk_right = (state == IDLE_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

    // Next state logic
    always @(*) begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = IDLE_RIGHT;
                end else if (bump_right) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = IDLE_LEFT;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = IDLE_LEFT;
                end else if (bump_right) begin
                    next_state = IDLE_RIGHT;
                end else begin
                    next_state = IDLE_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = IDLE_LEFT; // Changed to IDLE_LEFT
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (!dig) begin
                    next_state = IDLE_LEFT;
                end else begin
                    next_state = DIGGING;
                end
            end
            default: begin
                next_state = SPLATTERED;
            end
        endcase
    end

    // State and fall count update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALLING) begin
                fall_count <= fall_count + 1;
            end else begin
                fall_count <= 0;
            end
        end
    end

endmodule