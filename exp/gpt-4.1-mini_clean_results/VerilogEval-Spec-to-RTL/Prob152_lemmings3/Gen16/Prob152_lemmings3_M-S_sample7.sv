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

localparam WALK = 2'd0,
           FALL = 2'd1,
           DIG  = 2'd2;

reg [1:0] state, state_next;
reg dir, dir_next;

always @(*) begin
    state_next = state;
    dir_next = dir;

    case (state)
        WALK: begin
            if (!ground) begin
                state_next = FALL;
            end else if (dig) begin
                state_next = DIG;
            end else if (bump_left || bump_right) begin
                if (bump_left && bump_right)
                    dir_next = ~dir;
                else if (bump_left)
                    dir_next = 1'b1; // walk right
                else
                    dir_next = 1'b0; // walk left
            end
        end
        FALL: begin
            if (ground) begin
                state_next = WALK;
            end
        end
        DIG: begin
            if (!ground) begin
                state_next = FALL;
            end
        end
        default: begin
            state_next = WALK;
            dir_next = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK;
        dir <= 1'b0;
    end else begin
        state <= state_next;
        dir <= dir_next;
    end
end

assign walk_left  = (state == WALK) && (dir == 1'b0);
assign walk_right = (state == WALK) && (dir == 1'b1);
assign aaah       = (state == FALL);
assign digging    = (state == DIG);

endmodule