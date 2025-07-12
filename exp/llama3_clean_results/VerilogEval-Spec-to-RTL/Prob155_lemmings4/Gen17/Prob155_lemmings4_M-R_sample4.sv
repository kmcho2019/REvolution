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

reg [2:0] state; // 0 - IDLE, 1 - FALLING, 2 - DIGGING, 3 - SPLATTERED
reg walk_direction;
reg [4:0] fall_counter;

// Combinational logic for walking direction
always_comb begin
    if (bump_left && walk_direction) begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end else if (bump_right && ~walk_direction) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else if (state == 0) begin // IDLE state
        if (walk_direction) begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end else begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
    end else begin // FALLING or DIGGING or SPLATTERED state
        walk_left = 1'b0;
        walk_right = 1'b0;
    end
end

// Sequential logic for state transitions
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // IDLE state
        walk_direction <= 1'b0; // walk left initially
        fall_counter <= 5'b0;
        digging <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (~ground) begin
                    state <= 1; // FALLING state
                    fall_counter <= 5'b1;
                    aaah <= 1'b1;
                end else if (dig) begin
                    state <= 2; // DIGGING state
                    digging <= 1'b1;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
            end
            1: begin // FALLING state
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 3; // SPLATTERED state
                    end else begin
                        state <= 0; // IDLE state
                        aaah <= 1'b0;
                        fall_counter <= 5'b0;
                    end
                end else begin
                    fall_counter <= fall_counter + 1'b1;
                    aaah <= 1'b1;
                end
            end
            2: begin // DIGGING state
                if (~ground) begin
                    state <= 1; // FALLING state
                    digging <= 1'b0;
                    aaah <= 1'b1;
                end else if (~dig) begin
                    state <= 0; // IDLE state
                    digging <= 1'b0;
                end
            end
            3: begin // SPLATTERED state
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule