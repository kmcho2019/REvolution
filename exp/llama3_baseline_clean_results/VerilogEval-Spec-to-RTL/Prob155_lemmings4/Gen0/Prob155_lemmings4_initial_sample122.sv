module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [4:0] fall_count; // counter for the number of clock cycles a Lemming has been falling
reg previous_direction; // stores the previous direction of the Lemming when it starts falling

reg [2:0] state, next_state; // state register

// state encoding
parameter idle_left = 3'b001;
parameter idle_right = 3'b010;
parameter falling = 3'b011;
parameter digging_left = 3'b100;
parameter digging_right = 3'b101;
parameter dead = 3'b110;

// output logic
always @(*) begin
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;
    case(state)
        idle_left: begin
            walk_left = 1;
        end
        idle_right: begin
            walk_right = 1;
        end
        falling: begin
            aaah = 1;
        end
        digging_left: begin
            walk_left = 1;
            digging = 1;
        end
        digging_right: begin
            walk_right = 1;
            digging = 1;
        end
        default: ;
    endcase
end

// next state logic
always @(*) begin
    next_state = state;
    case(state)
        idle_left: begin
            if(!ground) begin
                next_state = falling;
            end else if(dig) begin
                next_state = digging_left;
            end else if(bump_left) begin
                next_state = idle_right;
            end else if(bump_right) begin
                next_state = idle_left;
            end
        end
        idle_right: begin
            if(!ground) begin
                next_state = falling;
            end else if(dig) begin
                next_state = digging_right;
            end else if(bump_left) begin
                next_state = idle_right;
            end else if(bump_right) begin
                next_state = idle_left;
            end
        end
        falling: begin
            if(ground) begin
                if(fall_count > 20) begin
                    next_state = dead;
                end else if(previous_direction) begin
                    next_state = idle_left;
                end else begin
                    next_state = idle_right;
                end
            end
        end
        digging_left: begin
            if(!ground) begin
                next_state = falling;
                previous_direction = 1'b1;
            end
        end
        digging_right: begin
            if(!ground) begin
                next_state = falling;
                previous_direction = 1'b0;
            end
        end
        dead: begin
            // stay in dead state
        end
        default: ;
    endcase
end

// sequential logic
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= idle_left;
        fall_count <= 0;
        previous_direction <= 1'b1;
    end else begin
        if(state == falling) begin
            fall_count <= fall_count + 1;
        end else begin
            fall_count <= 0;
        end
        state <= next_state;
    end
end

endmodule