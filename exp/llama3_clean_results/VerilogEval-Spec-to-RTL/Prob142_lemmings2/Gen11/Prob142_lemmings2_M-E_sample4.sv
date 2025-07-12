module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg walk_dir; // 1: walking right, 0: walking left
reg [1:0] state; // 2'b00: walking, 2'b01: falling

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        2'b00: // walking
            begin
                if (~ground) begin
                    state = 2'b01; // falling
                end else if (bump_left && ~walk_dir) begin
                    walk_dir = 1'b1; // walking right
                end else if (bump_right && walk_dir) begin
                    walk_dir = 1'b0; // walking left
                end
            end
        2'b01: // falling
            begin
                if (ground) begin
                    state = 2'b00; // walking
                end
            end
    endcase
end

// Sequential logic to update the state and walking direction
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // walking
        walk_dir <= 1'b0; // walking left
    end else begin
        case(state)
            2'b00: // walking
                begin
                    if (~ground) begin
                        state <= 2'b01; // falling
                    end else if (bump_left && ~walk_dir) begin
                        walk_dir <= 1'b1; // walking right
                    end else if (bump_right && walk_dir) begin
                        walk_dir <= 1'b0; // walking left
                    end
                end
            2'b01: // falling
                begin
                    if (ground) begin
                        state <= 2'b00; // walking
                    end
                end
        endcase
    end
end

// Output logic
always @(*) begin
    case(state)
        2'b00: // walking
            begin
                walk_left = ~walk_dir;
                walk_right = walk_dir;
                aaah = 1'b0;
            end
        2'b01: // falling
            begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
            end
    endcase
end

endmodule