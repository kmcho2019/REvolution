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

    // State definitions
    localparam WALK = 1'b0;
    localparam FALL = 1'b1;

    reg state;      // Current state (WALK or FALL)
    reg direction;  // 0=left, 1=right
    wire next_direction;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
        end
        else begin
            case (state)
                WALK: state <= ground ? WALK : FALL;
                FALL: state <= ground ? WALK : FALL;
            endcase
        end
    end

    // Direction change logic (combinational)
    assign next_direction = (state == WALK && ground) ? 
                           ((direction && bump_right) || (!direction && bump_left) ? ~direction : direction) :
                           direction;

    // Direction register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
        end
        else begin
            direction <= next_direction;
        end
    end

    // Output assignments
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);

endmodule