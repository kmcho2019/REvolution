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

    // State encoding: 3 bits:
    // bit 0 = direction: 0=left,1=right
    // bit 1 = activity: 0=walking,1=falling/digging
    // bit 2 = digging flag: 0=not digging or falling, 1=digging (only meaningful when activity=1)
    // We'll define states explicitly:
    // Walking Left:  direction=0, activity=0
    // Walking Right: direction=1, activity=0
    // Digging Left:  direction=0, activity=1, digging=1
    // Digging Right: direction=1, activity=1, digging=1
    // Falling Left:  direction=0, activity=1, digging=0 (falling)
    // Falling Right: direction=1, activity=1, digging=0

    localparam WALK_L = 3'b000;
    localparam WALK_R = 3'b001;
    localparam DIG_L  = 3'b100;
    localparam DIG_R  = 3'b101;
    localparam FALL_L = 3'b010;
    localparam FALL_R = 3'b011;

    reg [2:0] state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            // Walking states (walking left or right)
            WALK_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                end else if (dig) begin
                    next_state = DIG_L;
                end else if (bump_left || bump_right) begin
                    // switch direction if bump on either side
                    // bump left or right, switch direction
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            WALK_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                end else if (dig) begin
                    next_state = DIG_R;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end

            // Digging states
            DIG_L: begin
                if (!ground) begin
                    next_state = FALL_L;
                end else begin
                    // remain digging while ground present
                    next_state = DIG_L;
                end
            end
            DIG_R: begin
                if (!ground) begin
                    next_state = FALL_R;
                end else begin
                    next_state = DIG_R;
                end
            end

            // Falling states
            FALL_L: begin
                if (ground) begin
                    // back to walking left after fall ends
                    next_state = WALK_L;
                end else begin
                    next_state = FALL_L;
                end
            end
            FALL_R: begin
                if (ground) begin
                    next_state = WALK_R;
                end else begin
                    next_state = FALL_R;
                end
            end

            default: next_state = WALK_L;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_L;
        else
            state <= next_state;
    end

    // Output logic: Moore outputs depend only on current state
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign digging    = (state == DIG_L) || (state == DIG_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule