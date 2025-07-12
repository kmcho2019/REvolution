module TopModule (
    input        clk,
    input        areset,
    input        bump_left,
    input        bump_right,
    input        ground,
    output       walk_left,
    output       walk_right,
    output       aaah
);

reg [1:0] state;
reg [1:0] state_next;

parameter walking_left = 2'b00;
parameter walking_right = 2'b01;
parameter falling = 2'b10;

always @(*) begin
    case(state)
        walking_left: begin
            if (bump_left || (bump_left && bump_right)) begin
                state_next = walking_right;
            end else if (bump_right || (bump_left && bump_right)) begin
                state_next = walking_right;
            end else if (!ground) begin
                state_next = falling;
            end else begin
                state_next = walking_left;
            end
        end
        walking_right: begin
            if (bump_right || (bump_left && bump_right)) begin
                state_next = walking_left;
            end else if (bump_left || (bump_left && bump_right)) begin
                state_next = walking_left;
            end else if (!ground) begin
                state_next = falling;
            end else begin
                state_next = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                state_next = state; // maintain the previous walking direction
            end else begin
                state_next = falling;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        state <= state_next;
    end
end

assign walk_left = (state == walking_left);
assign walk_right = (state == walking_right);
assign aaah = (state == falling);

endmodule