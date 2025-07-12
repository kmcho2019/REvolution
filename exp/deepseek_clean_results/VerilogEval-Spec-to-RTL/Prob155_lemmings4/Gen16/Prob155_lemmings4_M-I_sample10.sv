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
            direction <= 1;
            fall_count <= 0;
        end else case (state)
            WALK: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end else if (dig && ground) begin
                    state <= DIG;
                end else if ((bump_left || bump_right) && ground) begin
                    direction <= ~direction;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    state <= FALL;
                    fall_count <= 0;
                end
            end
            
            FALL: begin
                if (ground) begin
                    state <= (fall_count > 20) ? SPLAT : WALK;
                    fall_count <= 0;
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            
            SPLAT: state <= SPLAT;
        endcase
    end

    // Output logic (Moore style)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (state)
            WALK: begin
                walk_left = direction;
                walk_right = ~direction;
            end
            DIG: digging = 1;
            FALL: aaah = 1;
            SPLAT: ;
        endcase
    end

endmodule