module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: 3 bits
    // [2:1] mode: 2'b00=walk, 2'b01=dig, 2'b10=fall, 2'b11=splat
    // [0]   dir: 0=left, 1=right
    reg [2:0] state, next_state;
    reg [4:0] fall_timer, next_fall_timer;

    wire [1:0] mode = state[2:1];
    wire direction = state[0];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000;       // walk left
            fall_timer <= 0;
        end else begin
            state <= next_state;
            fall_timer <= next_fall_timer;
        end
    end

    always @(*) begin
        // defaults: hold state and fall_timer if falling, else reset timer
        next_state = state;
        next_fall_timer = (mode == 2'b10) ? ((fall_timer == 5'd31) ? 5'd31 : fall_timer + 1) : 5'd0;

        case (mode)
            2'b11: begin // splat - stuck forever
                next_state = state;
            end
            2'b10: begin // falling
                if (ground) begin
                    if (fall_timer > 5'd20)
                        next_state = {2'b11, direction}; // splat
                    else
                        next_state = {2'b00, direction}; // walk same dir
                    next_fall_timer = 0;
                end
            end
            2'b00: begin // walking
                if (!ground) begin
                    next_state = {2'b10, direction}; // start falling
                    next_fall_timer = 1;
                end else if (dig) begin
                    next_state = {2'b01, direction}; // start digging
                end else if (bump_left || bump_right) begin
                    // switch direction on bump(s)
                    // if both bump left and right or either, flip direction
                    if (bump_left && bump_right)
                        next_state = {2'b00, ~direction};
                    else if (bump_left)
                        next_state = {2'b00, 1'b1}; // walk right
                    else if (bump_right)
                        next_state = {2'b00, 1'b0}; // walk left
                end
            end
            2'b01: begin // digging
                if (!ground) begin
                    next_state = {2'b10, direction}; // fall on ground gone
                    next_fall_timer = 1;
                end
            end
        endcase
    end

    assign walk_left  = (mode == 2'b00) && (direction == 0);
    assign walk_right = (mode == 2'b00) && (direction == 1);
    assign aaah       = (mode == 2'b10);
    assign digging    = (mode == 2'b01);

endmodule