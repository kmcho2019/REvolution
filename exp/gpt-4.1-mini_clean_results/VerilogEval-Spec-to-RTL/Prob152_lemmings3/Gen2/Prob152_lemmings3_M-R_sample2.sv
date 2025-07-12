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

    // State encoding
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;

    reg [1:0] state, next_state;
    reg       dir, next_dir; // direction: 0=left, 1=right

    // Sequential logic: state and direction registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            dir <= next_dir;
        end
    end

    // Combinational next state and direction logic
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_dir = dir;

        case (state)
            WALK: begin
                if (!ground) begin
                    // Fall takes precedence
                    next_state = FALL;
                    // direction unchanged
                end else if (dig) begin
                    // Dig if dig=1 and ground=1
                    next_state = DIG;
                    // direction unchanged
                end else if (bump_left || bump_right) begin
                    // Switch direction on bump(s)
                    next_dir = ~dir;
                    // remain walking
                    next_state = WALK;
                end else begin
                    // stay walking same direction
                    next_state = WALK;
                    next_dir = dir;
                end
            end
            FALL: begin
                if (ground) begin
                    // Resume walking same direction
                    next_state = WALK;
                    // direction unchanged
                end else begin
                    // remain falling
                    next_state = FALL;
                    next_dir = dir;
                end
            end
            DIG: begin
                if (!ground) begin
                    // Start falling when reach other side
                    next_state = FALL;
                    // direction unchanged
                end else begin
                    // continue digging
                    next_state = DIG;
                    next_dir = dir;
                end
            end
            default: begin
                // Defensive fallback to walking left
                next_state = WALK;
                next_dir = 1'b0;
            end
        endcase
    end

    // Output logic (Moore outputs)
    assign walk_left  = (state == WALK) && (dir == 1'b0);
    assign walk_right = (state == WALK) && (dir == 1'b1);
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule