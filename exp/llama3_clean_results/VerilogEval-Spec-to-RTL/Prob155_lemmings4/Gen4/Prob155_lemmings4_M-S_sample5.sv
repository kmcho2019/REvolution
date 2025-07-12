module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    enum logic [1:0] {
        WALKING,
        FALLING,
        SPLATTERED
    } state;

    reg [4:0] fall_count;
    reg walk_direction;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALKING;
            fall_count <= 0;
            walk_direction <= 1;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            case(state)
                WALKING: begin
                    if(walk_direction) walk_left <= 1;
                    else walk_left <= 0;
                    walk_right <=!walk_left;
                    if(bump_left &&!walk_direction) walk_direction <= 1;
                    else if(bump_right && walk_direction) walk_direction <= 0;
                    if(dig && ground) digging <= 1;
                    else digging <= 0;
                    if(!ground) begin
                        state <= FALLING;
                        aaah <= 1;
                    end else if(dig &&!ground) begin
                        state <= FALLING;
                        aaah <= 1;
                    end
                end
                FALLING: begin
                    aaah <= 1;
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) state <= SPLATTERED;
                        else state <= WALKING;
                        aaah <= 0;
                    end
                end
                SPLATTERED: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            endcase
        end
    end
endmodule