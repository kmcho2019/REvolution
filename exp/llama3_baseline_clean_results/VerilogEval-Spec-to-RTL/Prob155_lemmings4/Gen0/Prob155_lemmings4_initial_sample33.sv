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

// State register encoding
parameter WL = 3'b000;
parameter WR = 3'b001;
parameter F = 3'b010;
parameter DL = 3'b011;
parameter DR = 3'b100;
parameter S = 3'b101;

reg [2:0] state;
reg [2:0] next_state;

reg [5:0] fall_counter;

reg walking_left;

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
        fall_counter <= 0;
        walking_left <= 1;
    end else begin
        state <= next_state;
        if ((state == F && ground) || (state == DL && ~ground) || (state == DR && ~ground)) begin
            if (fall_counter > 20) begin
                state <= S;
            end else if (state == F) begin
                fall_counter <= 0;
            end
        end else if (state == F) begin
            fall_counter <= fall_counter + 1;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
        WL: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WR: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        F: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DL: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        DR: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 1;
        end
        S: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

// Next state logic
always @(*) begin
    case (state)
        WL: begin
            if (~ground) begin
                next_state = F;
            end else if (bump_left) begin
                next_state = WR;
            end else if (dig) begin
                next_state = DL;
            end else if (bump_right) begin
                next_state = WR;
            end else begin
                next_state = WL;
            end
        end
        WR: begin
            if (~ground) begin
                next_state = F;
            end else if (bump_right) begin
                next_state = WL;
            end else if (dig) begin
                next_state = DR;
            end else if (bump_left) begin
                next_state = WL;
            end else begin
                next_state = WR;
            end
        end
        F: begin
            if (ground) begin
                if (walking_left) begin
                    next_state = WL;
                end else begin
                    next_state = WR;
                end
            end else begin
                next_state = F;
            end
        end
        DL: begin
            if (~ground) begin
                next_state = F;
            end else begin
                next_state = DL;
            end
        end
        DR: begin
            if (~ground) begin
                next_state = F;
            end else begin
                next_state = DR;
            end
        end
        S: begin
            next_state = S;
        end
    endcase
end

// Update walking direction
always @(*) begin
    case (state)
        WL: begin
            walking_left = 1;
        end
        WR: begin
            walking_left = 0;
        end
        F: begin
            // walking direction remains the same
        end
        DL: begin
            walking_left = 1;
        end
        DR: begin
            walking_left = 0;
        end
        S: begin
            // walking direction is irrelevant in splattered state
        end
    endcase
end

endmodule