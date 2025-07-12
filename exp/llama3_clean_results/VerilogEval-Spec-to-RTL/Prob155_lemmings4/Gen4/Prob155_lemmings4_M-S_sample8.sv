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

    reg [2:0] state;
    reg [4:0] fall_count;
    reg walk_direction;

    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            3'b001: begin // WALKING
                if(walk_direction) walk_left = 1;
                else walk_right = 1;
                if(dig) digging = 1;
                if(bump_left &&!walk_direction) walk_direction = 1;
                else if(bump_right && walk_direction) walk_direction = 0;
                if(!ground) state = 3'b010; // FALLING
            end
            3'b010: begin // FALLING
                aaah = 1;
                if(ground) begin
                    if(fall_count > 20) state = 3'b100; // SPLATTERED
                    else state = 3'b001; // WALKING
                end else fall_count = fall_count + 1;
            end
            3'b100: begin // SPLATTERED
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= 3'b001;
            fall_count <= 0;
            walk_direction <= 1;
        end else begin
            if(state == 3'b010) fall_count <= fall_count + 1;
            else fall_count <= 0;
            state <= state;
        end
    end
endmodule