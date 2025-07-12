module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    parameter WALK_L = 3'b000;
    parameter WALK_R = 3'b001;
    parameter DIG_L  = 3'b010;
    parameter DIG_R  = 3'b011;
    parameter FALL   = 3'b100;
    parameter SPLAT  = 3'b101;

    reg [2:0] state;
    reg [4:0] fall_timer;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_timer <= 0;
        end else begin
            case (state)
                WALK_L, WALK_R: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 0;
                    end else if (dig) begin
                        state <= (state == WALK_L) ? DIG_L : DIG_R;
                    end else if ((state == WALK_L && bump_left) || 
                               (state == WALK_R && bump_right)) begin
                        state <= (state == WALK_L) ? WALK_R : WALK_L;
                    end
                end
                
                DIG_L, DIG_R: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_timer <= 0;
                    end
                end
                
                FALL: begin
                    fall_timer <= fall_timer + 1;
                    if (ground) begin
                        if (fall_timer > 20)
                            state <= SPLAT;
                        else
                            state <= (fall_timer[0]) ? WALK_R : WALK_L; // Alternate for demo
                    end
                end
                
                SPLAT: state <= SPLAT;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            WALK_L: {walk_left, walk_right, aaah, digging} = 4'b1000;
            WALK_R: {walk_left, walk_right, aaah, digging} = 4'b0100;
            DIG_L:  {walk_left, walk_right, aaah, digging} = 4'b0001;
            DIG_R:  {walk_left, walk_right, aaah, digging} = 4'b0001;
            FALL:   {walk_left, walk_right, aaah, digging} = 4'b0010;
            SPLAT:  {walk_left, walk_right, aaah, digging} = 4'b0000;
            default: {walk_left, walk_right, aaah, digging} = 4'b0000;
        endcase
    end

endmodule