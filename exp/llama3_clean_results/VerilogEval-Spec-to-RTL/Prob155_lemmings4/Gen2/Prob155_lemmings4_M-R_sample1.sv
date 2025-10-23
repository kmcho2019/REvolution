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

    enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state, next_state;

    reg [4:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            case(state)
                WALK_LEFT: begin
                    if(bump_right) state <= WALK_RIGHT;
                    else if(dig && ground) state <= DIGGING;
                    else if(!ground) state <= FALLING;
                end
                WALK_RIGHT: begin
                    if(bump_left) state <= WALK_LEFT;
                    else if(dig && ground) state <= DIGGING;
                    else if(!ground) state <= FALLING;
                end
                FALLING: begin
                    if(ground) begin
                        if(fall_count > 20) state <= SPLATTERED;
                        else if(state == FALLING) state <= WALK_LEFT;
                    end else fall_count <= fall_count + 1;
                end
                DIGGING: begin
                    if(!ground) state <= FALLING;
                end
                SPLATTERED: ;
            endcase
        end
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule