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

reg [1:0] state;
reg [1:0] state_next;
reg prev_walk_left;
reg prev_walk_right;

// Asynchronous reset
always @(*) begin
    if (areset) begin
        state_next = 2'b00; // Initial state: walking left
    end else begin
        case (state)
            2'b00: begin // Walking left
                if (~ground) begin
                    state_next = 2'b11; // Falling
                end else if (bump_left) begin
                    state_next = 2'b01; // Walking right
                end else if (bump_right) begin
                    state_next = 2'b00; // Still walking left, but needs to be set
                end else if (bump_left && bump_right) begin
                    state_next = 2'b01; // Walking right
                end else begin
                    state_next = 2'b00; // Still walking left
                end
            end
            2'b01: begin // Walking right
                if (~ground) begin
                    state_next = 2'b11; // Falling
                end else if (bump_left) begin
                    state_next = 2'b00; // Walking left
                end else if (bump_right) begin
                    state_next = 2'b01; // Still walking right
                end else if (bump_left && bump_right) begin
                    state_next = 2'b00; // Walking left
                end else begin
                    state_next = 2'b01; // Still walking right
                end
            end
            2'b11: begin // Falling
                if (ground) begin
                    if (prev_walk_left) begin
                        state_next = 2'b00; // Walking left
                    end else if (prev_walk_right) begin
                        state_next = 2'b01; // Walking right
                    end else begin
                        state_next = 2'b00; // Walking left by default
                    end
                end else begin
                    state_next = 2'b11; // Still falling
                end
            end
            default: state_next = 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    state <= state_next;
    if (state == 2'b00) begin
        prev_walk_left <= 1'b1;
        prev_walk_right <= 1'b0;
    end else if (state == 2'b01) begin
        prev_walk_left <= 1'b0;
        prev_walk_right <= 1'b1;
    end
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b11);

endmodule