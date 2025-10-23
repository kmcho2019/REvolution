module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] current_state, next_state;
reg [1:0] previous_state;

always @(*) begin
    case (current_state)
        2'b00: begin // walking_left
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_left) begin
                next_state = 2'b01; // walking_right
            end else begin
                next_state = 2'b00; // walking_left
            end
        end
        2'b01: begin // walking_right
            if (~ground) begin
                next_state = 2'b10; // falling
            end else if (bump_right) begin
                next_state = 2'b00; // walking_left
            end else begin
                next_state = 2'b01; // walking_right
            end
        end
        2'b10: begin // falling
            if (ground) begin
                next_state = 2'b11; // waiting_to_recover
            end else begin
                next_state = 2'b10; // falling
            end
        end
        2'b11: begin // waiting_to_recover
            if (previous_state == 2'b00) begin
                next_state = 2'b00; // walking_left
            end else begin
                next_state = 2'b01; // walking_right
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 2'b00;
        previous_state <= 2'b00;
    end else begin
        previous_state <= current_state;
        current_state <= next_state;
    end
end

always @(*) begin
    case (current_state)
        2'b00: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
        2'b01: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
        end
        2'b10: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
        end
        2'b11: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
        end
    endcase
end

endmodule