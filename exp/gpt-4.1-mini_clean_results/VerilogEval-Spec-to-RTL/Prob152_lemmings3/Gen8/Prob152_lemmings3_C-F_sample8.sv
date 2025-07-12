module TopModule(
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    input        ground,
    input        dig,
    output       walk_left,
    output       walk_right,
    output       aaah,
    output       digging
);

    // State encoding (3 bits):
    // bit 2: digging (1 = digging)
    // bit 1: falling (1 = falling)
    // bit 0: direction (0 = left, 1 = right)
    //
    // 000 - walk left
    // 001 - walk right
    // 010 - fall left
    // 011 - fall right
    // 100 - dig left
    // 101 - dig right

    reg [2:0] state, next_state;

    // Combinational next state logic with priority:
    // falling > digging > bump direction switching
    always @(*) begin
        next_state = state; // default hold

        case (state)
            3'b000: begin // walk left
                if (!ground) begin
                    // fall left
                    next_state = 3'b010;
                end else if (dig) begin
                    // dig left
                    next_state = 3'b100;
                end else if (bump_left || bump_right) begin
                    // bump either side flips direction to right
                    next_state = 3'b001;
                end else begin
                    // continue walk left
                    next_state = 3'b000;
                end
            end
            3'b001: begin // walk right
                if (!ground) begin
                    // fall right
                    next_state = 3'b011;
                end else if (dig) begin
                    // dig right
                    next_state = 3'b101;
                end else if (bump_left || bump_right) begin
                    // bump either side flips direction to left
                    next_state = 3'b000;
                end else begin
                    // continue walk right
                    next_state = 3'b001;
                end
            end
            3'b010: begin // fall left
                if (ground) begin
                    // ground returned: walk left (same direction)
                    next_state = 3'b000;
                end else begin
                    // continue falling left
                    next_state = 3'b010;
                end
            end
            3'b011: begin // fall right
                if (ground) begin
                    // ground returned: walk right
                    next_state = 3'b001;
                end else begin
                    // continue falling right
                    next_state = 3'b011;
                end
            end
            3'b100: begin // dig left
                if (!ground) begin
                    // ground lost: start falling left
                    next_state = 3'b010;
                end else begin
                    // continue digging left
                    next_state = 3'b100;
                end
            end
            3'b101: begin // dig right
                if (!ground) begin
                    // ground lost: start falling right
                    next_state = 3'b011;
                end else begin
                    // continue digging right
                    next_state = 3'b101;
                end
            end
            default: begin
                next_state = 3'b000; // safety fallback: walk left
            end
        endcase
    end

    // Sequential update with asynchronous reset and conditional update to minimize toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000; // walk left on reset
        end else if (state != next_state) begin
            state <= next_state;
        end
    end

    // Outputs decoded directly from state bits
    assign walk_left  = (state == 3'b000);
    assign walk_right = (state == 3'b001);
    assign aaah       = state[1]; // falling states have bit 1 set
    assign digging    = state[2]; // digging states have bit 2 set

endmodule