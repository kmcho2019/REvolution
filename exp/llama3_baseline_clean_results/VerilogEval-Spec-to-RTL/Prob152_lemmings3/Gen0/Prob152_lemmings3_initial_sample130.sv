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

    reg [2:0] state, next_state;
    parameter WL = 3'b001, WR = 3'b010, DL = 3'b011, DR = 3'b100, F = 3'b101, GL = 3'b110, GR = 3'b111;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WL: begin
                if (!ground) begin
                    next_state = GL;
                end else if (bump_left) begin
                    next_state = WR;
                end else if (dig) begin
                    next_state = DL;
                end else begin
                    next_state = WL;
                end
            end
            WR: begin
                if (!ground) begin
                    next_state = GR;
                end else if (bump_right) begin
                    next_state = WL;
                end else if (dig) begin
                    next_state = DR;
                end else begin
                    next_state = WR;
                end
            end
            DL: begin
                if (!ground) begin
                    next_state = F;
                end else begin
                    next_state = DL;
                end
            end
            DR: begin
                if (!ground) begin
                    next_state = F;
                end else begin
                    next_state = DR;
                end
            end
            F: begin
                if (ground) begin
                    if (next_state == GL) begin
                        next_state = WL;
                    end else if (next_state == GR) begin
                        next_state = WR;
                    end
                end else begin
                    next_state = F;
                end
            end
            GL: begin
                if (ground) begin
                    next_state = WL;
                end else begin
                    next_state = GL;
                end
            end
            GR: begin
                if (ground) begin
                    next_state = WR;
                end else begin
                    next_state = GR;
                end
            end
            default: next_state = WL;
        endcase
    end

    always @(*) begin
        case (state)
            WL: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            WR: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end
            DL: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
            DR: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
            F: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            GL: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            GR: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule