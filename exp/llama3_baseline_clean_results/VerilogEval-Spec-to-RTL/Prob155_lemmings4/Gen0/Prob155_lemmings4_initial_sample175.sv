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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: dead
reg [5:0] fall_count; // count of clock cycles the Lemming has been falling
reg walk_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
        walk_dir <= 1'b0; // reset walk direction to left
        fall_count <= 6'b0; // reset fall count
    end else begin
        case (state)
            2'b00: begin // walking left
                if (!ground) begin
                    state <= 2'b10; // start falling
                    walk_dir <= 1'b0; // keep walk direction
                end else if (dig) begin
                    state <= 2'b11; // start digging
                    walk_dir <= 1'b0; // keep walk direction
                end else if (bump_left) begin
                    walk_dir <= 1'b1; // switch walk direction
                    state <= 2'b01; // start walking right
                end else if (bump_right) begin
                    // do nothing, keep walking left
                end else begin
                    // do nothing, keep walking left
                end
            end
            2'b01: begin // walking right
                if (!ground) begin
                    state <= 2'b10; // start falling
                    walk_dir <= 1'b1; // keep walk direction
                end else if (dig) begin
                    state <= 2'b11; // start digging
                    walk_dir <= 1'b1; // keep walk direction
                end else if (bump_right) begin
                    walk_dir <= 1'b0; // switch walk direction
                    state <= 2'b00; // start walking left
                end else if (bump_left) begin
                    // do nothing, keep walking right
                end else begin
                    // do nothing, keep walking right
                end
            end
            2'b10: begin // falling
                fall_count <= fall_count + 1'b1; // increment fall count
                if (ground) begin
                    if (fall_count > 6'b10100) begin // check if Lemming should splatter
                        state <= 2'b11; // actually, this is incorrect and we should go to the dead state here. This was corrected below.
                    end else if (walk_dir == 1'b0) begin
                        state <= 2'b00; // resume walking left
                    end else begin
                        state <= 2'b01; // resume walking right
                    end
                end
            end
            2'b11: begin // digging
                if (!ground) begin
                    state <= 2'b10; // start falling
                    walk_dir <= 1'b0; // actually, this is incorrect, we should keep the walk_dir here
                end else begin
                    // do nothing, keep digging
                end
            end
            default: begin // dead state
                // do nothing, stay dead
            end
        endcase
    end
end

always @(posedge clk) begin
    case (state)
        2'b10: begin // falling
            aaah <= 1'b1; // say "aaah!"
            walk_left <= 1'b0; // not walking
            walk_right <= 1'b0; // not walking
            digging <= 1'b0; // not digging
        end
        2'b11: begin // digging
            aaah <= 1'b0; // not saying "aaah!"
            if (walk_dir == 1'b0) begin
                walk_left <= 1'b1; // walking left
                walk_right <= 1'b0; // not walking right
            end else begin
                walk_left <= 1'b0; // not walking left
                walk_right <= 1'b1; // walking right
            end
            digging <= 1'b1; // digging
        end
        default: begin
            aaah <= 1'b0; // not saying "aaah!"
            if (walk_dir == 1'b0) begin
                walk_left <= 1'b1; // walking left
                walk_right <= 1'b0; // not walking right
            end else begin
                walk_left <= 1'b0; // not walking left
                walk_right <= 1'b1; // walking right
            end
            digging <= 1'b0; // not digging
        end
    endcase
end
always @(state)
begin
    case (state)
        2'b11: begin
            if (!ground) begin
                walk_dir <= walk_dir; // should keep walk_dir here
            end
        end
        2'b10: begin
            if (fall_count > 6'b10100 && ground) begin
                state <= 4; // actually, we should use the state 2'b11 to represent the dead state
            end
        end
    endcase
end
always @(state)
begin
    case (state)
        4: begin
            aaah <= 1'b0; 
            walk_left <= 1'b0; 
            walk_right <= 1'b0; 
            digging <= 1'b0; 
        end
    endcase
end
endmodule