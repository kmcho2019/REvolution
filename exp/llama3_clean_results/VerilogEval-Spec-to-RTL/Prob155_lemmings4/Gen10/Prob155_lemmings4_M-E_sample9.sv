module TopModule(
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

// Define the modes
enum logic [1:0] {
    WALKING_MODE = 2'b00,
    FALLING_MODE = 2'b01,
    DIGGING_MODE = 2'b10,
    SPLATTERED_MODE = 2'b11
} mode, next_mode;

// Define the walking direction
reg walking_direction;

// Fall counter module
module fall_counter(
    input clk,
    input reset,
    input falling,
    output reg [4:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b0;
        end else if (falling) begin
            count <= count + 1'b1;
        end else begin
            count <= 5'b0;
        end
    end
endmodule

fall_counter fc(
   .clk(clk),
   .reset(areset),
   .falling(mode == FALLING_MODE),
   .count(fall_count)
);

// Walking state machine
module walking_sm(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input dig,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg digging,
    output reg next_mode
);
    reg [1:0] state;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
            walking_direction <= 1'b0; // walking left
        end else begin
            case (state)
                2'b00: begin // walking left
                    if (bump_left || bump_right) begin
                        state <= 2'b01; // walking right
                        walking_direction <= ~walking_direction;
                    end else if (dig && ground) begin
                        state <= 2'b10; // digging
                    end
                end
                2'b01: begin // walking right
                    if (bump_left || bump_right) begin
                        state <= 2'b00; // walking left
                        walking_direction <= ~walking_direction;
                    end else if (dig && ground) begin
                        state <= 2'b10; // digging
                    end
                end
                2'b10: begin // digging
                    if (!ground) begin
                        state <= 2'b00; // walking left
                    end
                end
            endcase
        end
    end
    assign walk_left = (state == 2'b00) &&!walking_direction;
    assign walk_right = (state == 2'b01) && walking_direction;
    assign digging = (state == 2'b10);
    assign next_mode = (state == 2'b10) &&!ground? FALLING_MODE : WALKING_MODE;
endmodule

walking_sm ws(
   .clk(clk),
   .areset(areset),
   .bump_left(bump_left),
   .bump_right(bump_right),
   .dig(dig),
   .ground(ground),
   .walk_left(walk_left),
   .walk_right(walk_right),
   .digging(digging),
   .next_mode(next_mode)
);

// Falling state machine
module falling_sm(
    input clk,
    input areset,
    input ground,
    input [4:0] fall_count,
    output reg aaah,
    output reg next_mode
);
    reg [1:0] state;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin // falling
                    if (ground) begin
                        if (fall_count > 5'd20) begin
                            state <= 2'b01; // splattered
                        end else begin
                            state <= 2'b10; // walking
                        end
                    end
                end
                2'b01: begin // splattered
                    state <= 2'b01;
                end
                2'b10: begin // walking
                    state <= 2'b10;
                end
            endcase
        end
    end
    assign aaah = (state == 2'b00);
    assign next_mode = (state == 2'b01)? SPLATTERED_MODE : (state == 2'b10)? WALKING_MODE : FALLING_MODE;
endmodule

falling_sm fs(
   .clk(clk),
   .areset(areset),
   .ground(ground),
   .fall_count(fall_count),
   .aaah(aaah),
   .next_mode(next_mode)
);

// Top-level state machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        mode <= WALKING_MODE;
    end else begin
        case (mode)
            WALKING_MODE: begin
                if (next_mode == FALLING_MODE) begin
                    mode <= FALLING_MODE;
                end else if (next_mode == DIGGING_MODE) begin
                    mode <= DIGGING_MODE;
                end
            end
            FALLING_MODE: begin
                if (next_mode == SPLATTERED_MODE) begin
                    mode <= SPLATTERED_MODE;
                end else if (next_mode == WALKING_MODE) begin
                    mode <= WALKING_MODE;
                end
            end
            DIGGING_MODE: begin
                if (next_mode == FALLING_MODE) begin
                    mode <= FALLING_MODE;
                end else if (next_mode == WALKING_MODE) begin
                    mode <= WALKING_MODE;
                end
            end
            SPLATTERED_MODE: begin
                mode <= SPLATTERED_MODE;
            end
        endcase
    end
end

endmodule