module TopModule(
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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging
reg [1:0] next_state;
reg walk_left_reg, walk_right_reg, aaah_reg, digging_reg;

// Output logic
assign walk_left = walk_left_reg;
assign walk_right = walk_right_reg;
assign aaah = aaah_reg;
assign digging = digging_reg;

// State logic
always @(*) begin
    case(state)
        2'b00: begin // walking left
            if(!ground) next_state = 2'b10; // falling
            else if(dig) next_state = 2'b11; // digging
            else if(bump_left) next_state = 2'b01; // walking right
            else if(bump_right) next_state = 2'b01; // walking right
            else next_state = 2'b00; // walking left
        end
        2'b01: begin // walking right
            if(!ground) next_state = 2'b10; // falling
            else if(dig) next_state = 2'b11; // digging
            else if(bump_left) next_state = 2'b00; // walking left
            else if(bump_right) next_state = 2'b00; // walking left
            else next_state = 2'b01; // walking right
        end
        2'b10: begin // falling
            if(ground) begin
                if(state == 2'b10) next_state = 2'b00; // walking left
                else if(state == 2'b11) next_state = 2'b01; // walking right
            end
            else next_state = 2'b10; // falling
        end
        2'b11: begin // digging
            if(!ground) next_state = 2'b10; // falling
            else next_state = 2'b11; // digging
        end
        default: next_state = 2'b00; // walking left
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // walking left
        walk_left_reg <= 1'b1;
        walk_right_reg <= 1'b0;
        aaah_reg <= 1'b0;
        digging_reg <= 1'b0;
    end
    else begin
        state <= next_state;
        case(next_state)
            2'b00: begin // walking left
                walk_left_reg <= 1'b1;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b0;
            end
            2'b01: begin // walking right
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b1;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b0;
            end
            2'b10: begin // falling
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b1;
                digging_reg <= 1'b0;
            end
            2'b11: begin // digging
                walk_left_reg <= 1'b0;
                walk_right_reg <= 1'b0;
                aaah_reg <= 1'b0;
                digging_reg <= 1'b1;
            end
        endcase
    end
end

endmodule