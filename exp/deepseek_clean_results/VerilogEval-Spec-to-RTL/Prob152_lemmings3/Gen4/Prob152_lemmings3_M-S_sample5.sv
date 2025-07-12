module TopModule (
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
    // Combined state and direction encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    reg [2:0] state_dir; // [1:0] = state, [2] = direction (0=left, 1=right)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_dir <= 3'b000; // WALK + left
        end else begin
            case (state_dir[1:0])
                WALK: begin
                    if (~ground) begin
                        state_dir[1:0] <= FALL;
                    end else if (dig) begin
                        state_dir[1:0] <= DIG;
                    end else if ((bump_left && ~state_dir[2]) || (bump_right && state_dir[2])) begin
                        state_dir[2] <= ~state_dir[2];
                    end
                end
                FALL: begin
                    if (ground) begin
                        state_dir[1:0] <= WALK;
                    end
                end
                DIG: begin
                    if (~ground) begin
                        state_dir[1:0] <= FALL;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state_dir[1:0] == WALK) && ~state_dir[2];
    assign walk_right = (state_dir[1:0] == WALK) && state_dir[2];
    assign aaah = (state_dir[1:0] == FALL);
    assign digging = (state_dir[1:0] == DIG);
endmodule