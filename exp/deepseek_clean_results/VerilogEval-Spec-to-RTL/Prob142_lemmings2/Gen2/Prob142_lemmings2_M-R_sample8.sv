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

    // One-hot state encoding
    reg [3:0] state;
    localparam WALK_L = 4'b0001,
               WALK_R = 4'b0010,
               FALL_L = 4'b0100,
               FALL_R = 4'b1000;

    // Next state and output logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            {walk_left, walk_right, aaah} <= 3'b100;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[0]: begin // WALK_L
                    if (!ground) begin
                        state <= FALL_L;
                        {walk_left, walk_right, aaah} <= 3'b001;
                    end else if (bump_left) begin
                        state <= WALK_R;
                        {walk_left, walk_right, aaah} <= 3'b010;
                    end
                end
                state[1]: begin // WALK_R
                    if (!ground) begin
                        state <= FALL_R;
                        {walk_left, walk_right, aaah} <= 3'b001;
                    end else if (bump_right) begin
                        state <= WALK_L;
                        {walk_left, walk_right, aaah} <= 3'b100;
                    end
                end
                state[2]: begin // FALL_L
                    if (ground) begin
                        state <= WALK_L;
                        {walk_left, walk_right, aaah} <= 3'b100;
                    end
                end
                state[3]: begin // FALL_R
                    if (ground) begin
                        state <= WALK_R;
                        {walk_left, walk_right, aaah} <= 3'b010;
                    end
                end
            endcase
        end
    end

endmodule