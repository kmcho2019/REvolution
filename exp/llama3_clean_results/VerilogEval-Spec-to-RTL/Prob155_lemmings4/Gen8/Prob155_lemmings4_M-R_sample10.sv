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

    reg [1:0] state, next_state;
    reg walk_dir, next_walk_dir;
    reg [4:0] fall_count;
    reg is_digging;

    // State encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG = 2'b10;
    parameter SPLAT = 2'b11;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK;
            walk_dir <= 1'b1; // 1 for left, 0 for right
            fall_count <= 0;
            is_digging <= 1'b0;
        end else begin
            case(state)
                WALK: begin
                    if(!ground) begin
                        next_state <= FALL;
                    end else if(dig &&!is_digging) begin
                        next_state <= DIG;
                        is_digging <= 1'b1;
                    end else if(bump_right && walk_dir) begin
                        next_walk_dir <= 1'b0;
                    end else if(bump_left &&!walk_dir) begin
                        next_walk_dir <= 1'b1;
                    end else begin
                        next_state <= WALK;
                        next_walk_dir <= walk_dir;
                    end
                end
                FALL: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) begin
                            next_state <= SPLAT;
                        end else begin
                            next_state <= WALK;
                            is_digging <= 1'b0;
                        end
                        fall_count <= 0;
                    end else begin
                        next_state <= FALL;
                    end
                end
                DIG: begin
                    if(!ground) begin
                        next_state <= FALL;
                        is_digging <= 1'b0;
                    end else begin
                        next_state <= DIG;
                    end
                end
                SPLAT: begin
                    next_state <= SPLAT;
                end
            endcase
            state <= next_state;
            walk_dir <= next_walk_dir;
        end
    end

    assign walk_left = (state == WALK && walk_dir)? 1'b1 : 1'b0;
    assign walk_right = (state == WALK &&!walk_dir)? 1'b1 : 1'b0;
    assign aaah = (state == FALL)? 1'b1 : 1'b0;
    assign digging = (state == DIG)? 1'b1 : 1'b0;

endmodule