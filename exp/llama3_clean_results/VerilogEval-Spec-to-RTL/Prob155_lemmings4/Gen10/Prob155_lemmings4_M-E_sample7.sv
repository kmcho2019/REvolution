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

reg [1:0] state; // 2'b00: walking, 2'b01: falling, 2'b10: digging, 2'b11: splattered
reg [4:0] fall_counter;
reg walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        fall_counter <= 5'b0;
        walk_direction <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // walking
                if (~ground) begin
                    state <= 2'b01;
                end else if (dig && ground) begin
                    state <= 2'b10;
                end else if (bump_left || bump_right) begin
                    walk_direction <= ~walk_direction;
                end
            end
            2'b01: begin // falling
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= 2'b11;
                    end else begin
                        state <= 2'b00;
                    end
                    fall_counter <= 5'b0;
                end
            end
            2'b10: begin // digging
                if (~ground) begin
                    state <= 2'b01;
                end
            end
            2'b11: begin // splattered
                // stay in this state forever
            end
        endcase
    end
end

always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;
    
    case (state)
        2'b00: begin // walking
            if (walk_direction) begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end else begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        end
        2'b01: begin // falling
            aaah = 1'b1;
        end
        2'b10: begin // digging
            digging = 1'b1;
            if (walk_direction) begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end else begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        end
        2'b11: begin // splattered
            // all outputs are 0
        end
    endcase
end

endmodule