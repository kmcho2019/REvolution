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

    // Unified state encoding:
    // [2:1] - action state (walking/falling/digging/splattered)
    // [0]   - direction (0=left, 1=right)
    reg [2:0] state;
    reg [4:0] fall_counter;

    // State encoding definitions
    localparam WALK_L = 3'b000;
    localparam WALK_R = 3'b001;
    localparam FALL_L = 3'b010;
    localparam FALL_R = 3'b011;
    localparam DIG_L  = 3'b100;
    localparam DIG_R  = 3'b101;
    localparam SPLAT  = 3'b110;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            case (state[2:1])
                // Walking states
                2'b00: begin
                    if (!ground) begin
                        state <= state[0] ? FALL_R : FALL_L;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= state[0] ? DIG_R : DIG_L;
                    end else if ((bump_left && !state[0]) || (bump_right && state[0])) begin
                        state <= state[0] ? WALK_L : WALK_R;
                    end
                end
                
                // Falling states
                2'b01: begin
                    if (ground) begin
                        if (fall_counter > 20)
                            state <= SPLAT;
                        else
                            state <= state[0] ? WALK_R : WALK_L;
                    end else begin
                        fall_counter <= fall_counter + 1;
                    end
                end
                
                // Digging states
                2'b10: begin
                    if (!ground) begin
                        state <= state[0] ? FALL_R : FALL_L;
                        fall_counter <= 0;
                    end
                end
                
                // Splattered state
                2'b11: begin
                    // Stay in splattered state
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state[2:1] == 2'b01);
    assign digging = (state[2:1] == 2'b10);

endmodule