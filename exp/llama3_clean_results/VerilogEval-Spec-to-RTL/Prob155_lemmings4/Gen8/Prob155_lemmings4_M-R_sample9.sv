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

    reg [2:0] state, next_state;
    reg walking_direction;
    reg [4:0] fall_count;
    reg is_digging;

    // State encoding
    parameter WALK = 3'b001;
    parameter FALL = 3'b010;
    parameter DIG = 3'b011;
    parameter SPLAT = 3'b100;

    always @(posedge clk or posedge areset) begin
        if(areset) begin
            state <= WALK;
            walking_direction <= 1'b1;
            fall_count <= 0;
            is_digging <= 1'b0;
        end else begin
            case(state)
                WALK: begin
                    if(!ground) begin
                        state <= FALL;
                    end else if(dig && !is_digging) begin
                        state <= DIG;
                        is_digging <= 1'b1;
                    end else if(bump_left && !walking_direction || bump_right && walking_direction) begin
                        walking_direction <= !walking_direction;
                    end
                end
                FALL: begin
                    fall_count <= fall_count + 1;
                    if(ground) begin
                        if(fall_count > 20) begin
                            state <= SPLAT;
                        end else begin
                            state <= WALK;
                            is_digging <= 1'b0;
                        end
                        fall_count <= 0;
                    end
                end
                DIG: begin
                    if(!ground) begin
                        state <= FALL;
                        is_digging <= 1'b0;
                    end
                end
                SPLAT: begin
                    state <= SPLAT;
                end
            endcase
        end
    end

    assign walk_left = (state == WALK && walking_direction) ? 1'b1 : 1'b0;
    assign walk_right = (state == WALK && !walking_direction) ? 1'b1 : 1'b0;
    assign aaah = (state == FALL) ? 1'b1 : 1'b0;
    assign digging = (state == DIG) ? 1'b1 : 1'b0;

endmodule