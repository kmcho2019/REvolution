module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    parameter WALK_L = 2'b00;
    parameter WALK_R = 2'b01;
    parameter FALL_L = 2'b10;
    parameter FALL_R = 2'b11;

    reg [1:0] state;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
        end
        else begin
            case (state)
                WALK_L: begin
                    if (!ground) state <= FALL_L;
                    else if (bump_left) state <= WALK_R;
                end
                WALK_R: begin
                    if (!ground) state <= FALL_R;
                    else if (bump_right) state <= WALK_L;
                end
                FALL_L: if (ground) state <= WALK_L;
                FALL_R: if (ground) state <= WALK_R;
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = state[1]; // Fall states have MSB set

endmodule