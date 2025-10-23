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

    // Movement states (direction)
    localparam MOVE_LEFT = 1'b0;
    localparam MOVE_RIGHT = 1'b1;
    reg move_state;

    // Action states
    localparam ACT_NONE = 2'b00;
    localparam ACT_FALL = 2'b01;
    localparam ACT_DIG  = 2'b10;
    localparam ACT_SPLATTER = 2'b11;
    reg [1:0] action_state;

    // Fall timer with saturation
    reg [4:0] fall_cycles;
    wire fall_timeout = (fall_cycles > 20);

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            move_state <= MOVE_LEFT;
            action_state <= ACT_NONE;
            fall_cycles <= 0;
        end else begin
            // Action state transitions (highest priority)
            case (action_state)
                ACT_NONE: begin
                    if (~ground) begin
                        action_state <= ACT_FALL;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        action_state <= ACT_DIG;
                    end
                end
                
                ACT_FALL: begin
                    if (ground) begin
                        action_state <= fall_timeout ? ACT_SPLATTER : ACT_NONE;
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= (fall_cycles == 5'b11111) ? fall_cycles : fall_cycles + 1;
                    end
                end
                
                ACT_DIG: begin
                    if (~ground) begin
                        action_state <= ACT_FALL;
                        fall_cycles <= 1;
                    end
                end
                
                ACT_SPLATTER: begin
                    // Stay in splatter forever
                end
            endcase

            // Movement state transitions (only when not in special action)
            if (action_state == ACT_NONE) begin
                case ({bump_left, bump_right})
                    2'b01: move_state <= MOVE_RIGHT;
                    2'b10: move_state <= MOVE_LEFT;
                    2'b11: move_state <= ~move_state;
                    default: move_state <= move_state;
                endcase
            end
        end
    end

    // Output logic
    assign walk_left = (action_state == ACT_NONE) && (move_state == MOVE_LEFT) && !ACT_SPLATTER;
    assign walk_right = (action_state == ACT_NONE) && (move_state == MOVE_RIGHT) && !ACT_SPLATTER;
    assign aaah = (action_state == ACT_FALL);
    assign digging = (action_state == ACT_DIG);

endmodule