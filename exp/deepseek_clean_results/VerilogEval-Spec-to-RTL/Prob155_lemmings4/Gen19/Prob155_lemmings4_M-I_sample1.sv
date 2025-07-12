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

    parameter WALK = 0;
    parameter DIG = 1;
    parameter FALL = 2;
    parameter SPLAT = 3;

    reg [1:0] state;
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_count;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // start walking left
            fall_count <= 0;
        end else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end else if (dig) begin
                    state <= DIG;
                end else if ((bump_left && !direction) || (bump_right && direction)) begin
                    direction <= ~direction;  // switch direction
                end
            end
            
            DIG: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end else if (!dig) begin
                    state <= WALK;
                end
            end
            
            FALL: begin
                if (!ground) begin
                    fall_count <= fall_count + 1;
                end else begin
                    if (fall_count > 20) begin
                        state <= SPLAT;
                    end else begin
                        state <= WALK;
                    end
                end
            end
            
            SPLAT: state <= SPLAT;  // stay in SPLAT forever
        endcase
    end

    // Output logic
    assign walk_left = (state == WALK) && !direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah = (state == FALL);
    assign digging = (state == DIG) && ground;

endmodule