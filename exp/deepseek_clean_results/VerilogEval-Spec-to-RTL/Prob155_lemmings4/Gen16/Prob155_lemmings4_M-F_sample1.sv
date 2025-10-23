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

    parameter WALK = 0;
    parameter DIG = 1;
    parameter FALL = 2;
    parameter SPLAT = 3;

    reg [1:0] state;
    reg direction;  // 1=left, 0=right
    reg [4:0] fall_count;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 1;  // start walking left
            fall_count <= 0;
        end else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end else if (dig) begin
                    state <= DIG;
                end else if (bump_left || bump_right) begin
                    if (bump_left && bump_right)
                        direction <= ~direction;  // toggle if both bumps
                    else
                        direction <= bump_left;  // set to left if left bump, else right
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
                fall_count <= fall_count + 1;
                if (ground) begin
                    state <= (fall_count > 20) ? SPLAT : WALK;
                end
            end
            
            SPLAT: state <= SPLAT;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        case (state)
            WALK: begin
                walk_left = direction;
                walk_right = ~direction;
                aaah = 0;
                digging = 0;
            end
            DIG: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            FALL: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            SPLAT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule