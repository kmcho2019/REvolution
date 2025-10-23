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

    // State encoding
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;
    localparam SPLAT = 2'b11;

    reg [1:0] state, next_state;
    reg direction;  // 0: left, 1: right
    reg [4:0] fall_count;

    // Next state and direction logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else begin
                    next_state = WALK;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = (fall_count > 20) ? SPLAT : WALK;
                end else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                if (~ground) begin
                    next_state = FALL;
                end else begin
                    next_state = DIG;
                end
            end
            SPLAT: next_state = SPLAT;
            default: next_state = WALK;
        endcase
    end

    // Direction update logic (only in WALK state)
    wire next_direction = (state == WALK) ? 
                         (bump_left ? 1'b1 : 
                          (bump_right ? 1'b0 : direction)) : 
                         direction;

    // Fall counter logic
    wire [4:0] next_fall_count = (state == FALL && ~ground) ? fall_count + 1 : 5'b0;

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1'b0;  // start walking left
            fall_count <= 5'b0;
        end else begin
            state <= next_state;
            direction <= next_direction;
            fall_count <= next_fall_count;
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~direction & ~digging & ~aaah;
    assign walk_right = (state == WALK) & direction & ~digging & ~aaah;
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule