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

    // State encoding (3 bits): [2]digging, [1]falling, [0]direction (0=left,1=right)
    // 000: walk left
    // 001: walk right
    // 010: fall left
    // 011: fall right
    // 100: dig left
    // 101: dig right

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = state; // default stay

        case (state)
            3'b000: begin // walk left
                if (!ground)           next_state = 3'b010;      // fall left
                else if (dig)          next_state = 3'b100;      // dig left
                else if (bump_left || (bump_left && bump_right)) next_state = 3'b001; // walk right
                else if (bump_right)   next_state = 3'b000;       // walk left (no change)
                else                   next_state = 3'b000;       // walk left
            end
            3'b001: begin // walk right
                if (!ground)           next_state = 3'b011;      // fall right
                else if (dig)          next_state = 3'b101;      // dig right
                else if (bump_right || (bump_left && bump_right)) next_state = 3'b000; // walk left
                else if (bump_left)    next_state = 3'b001;       // walk right (no change)
                else                   next_state = 3'b001;       // walk right
            end
            3'b010: begin // fall left
                if (ground)            next_state = 3'b000;       // walk left
                else                   next_state = 3'b010;       // fall left
            end
            3'b011: begin // fall right
                if (ground)            next_state = 3'b001;       // walk right
                else                   next_state = 3'b011;       // fall right
            end
            3'b100: begin // dig left
                if (!ground)           next_state = 3'b010;       // fall left
                else                   next_state = 3'b100;       // dig left
            end
            3'b101: begin // dig right
                if (!ground)           next_state = 3'b011;       // fall right
                else                   next_state = 3'b101;       // dig right
            end
            default: next_state = 3'b000; // fallback to walk left
        endcase
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000; // walk left
        end else begin
            state <= next_state;
        end
    end

    // Output decoding
    assign walk_left  = (state == 3'b000);
    assign walk_right = (state == 3'b001);
    assign aaah       = (state[1]);  // falling states have bit 1 set
    assign digging    = (state[2]);  // digging states have bit 2 set

endmodule