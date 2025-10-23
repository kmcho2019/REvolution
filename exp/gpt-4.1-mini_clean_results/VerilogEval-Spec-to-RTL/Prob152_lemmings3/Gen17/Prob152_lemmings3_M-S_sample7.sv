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

    // State encoding (2 bits):
    // bit 1: direction (0=left, 1=right)
    // bit 0: mode: 0=walk, 1=fall, 2=dig (use 2-bit so dig=2)
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG  = 2'b10;

    reg [1:0] state, next_state; // {direction, mode}
    wire direction = state[1];
    wire [1:0] mode = state[0] ? (state[1] ? FALL : FALL) : WALK; // We'll encode mode in bit0+direction

    // Redefine mode as separate signal for clarity:
    wire [1:0] curr_mode = state[0] ? ((state[1]) ? FALL : FALL) : WALK; // not fully accurate, so we store full mode in bits

    // We'll use bits as:
    // bit1: direction
    // bit0: mode with:
    // 0 = walk, 1 = fall, 0 with digging bit set separately for dig mode

    // To simplify, separate mode into 2 bits:
    // We'll keep mode in bit0 for walk(0), fall(1), dig is differentiated by a flag in bit0=0 + digging flag
    // To simplify even more, just use 3 states: walk, fall, dig per direction by combining two bits:
    // Use 3-bit state: {direction, mode[1:0]} = direction(1bit), mode(2bits)
    // mode encoding: 2'b00=walk, 2'b01=fall, 2'b10=dig

    reg [2:0] full_state, next_full_state; // {direction, mode[1:0]}

    localparam MODE_WALK = 2'b00;
    localparam MODE_FALL = 2'b01;
    localparam MODE_DIG  = 2'b10;

    wire [1:0] mode_bits = full_state[1:0];
    wire dir_bit = full_state[2];

    always @(*) begin
        next_full_state = full_state;

        if (!ground) begin
            // Falling overrides all, no digging while falling
            next_full_state = {dir_bit, MODE_FALL};
        end else begin
            case (mode_bits)
                MODE_FALL: begin
                    // Ground back, stop falling, return to walk same direction
                    next_full_state = {dir_bit, MODE_WALK};
                end
                MODE_DIG: begin
                    // Continue digging on ground; if ground lost, start falling
                    if (!ground) begin
                        next_full_state = {dir_bit, MODE_FALL};
                    end else begin
                        next_full_state = full_state; // continue digging
                    end
                end
                default: begin // MODE_WALK
                    if (dig && ground) begin
                        // Start digging only if on ground and walking
                        next_full_state = {dir_bit, MODE_DIG};
                    end else if (bump_left || bump_right) begin
                        // Switch direction on bump only when walking on ground and not digging
                        // Bump priority: if both or one bump, switch direction accordingly
                        if (bump_left && bump_right)
                            next_full_state = {!dir_bit, MODE_WALK};
                        else if (bump_left)
                            next_full_state = {1'b1, MODE_WALK};
                        else
                            next_full_state = {1'b0, MODE_WALK};
                    end else begin
                        next_full_state = full_state; // continue walking same direction
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            full_state <= {1'b0, MODE_WALK}; // walk-left start
        else
            full_state <= next_full_state;
    end

    assign walk_left  = (mode_bits == MODE_WALK) && (dir_bit == 1'b0);
    assign walk_right = (mode_bits == MODE_WALK) && (dir_bit == 1'b1);
    assign aaah       = (mode_bits == MODE_FALL);
    assign digging    = (mode_bits == MODE_DIG);

endmodule