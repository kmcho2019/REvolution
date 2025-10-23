module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

reg [4:0] fall_count; // Counter to track fall duration
reg current_state, next_state;
reg [1:0] direction; // 0: left, 1: right
reg dig_signal;

// Define states
localparam IDLE_LEFT = 2'b00;
localparam IDLE_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING_LEFT = 2'b11;
localparam DIGGING_RIGHT = 2'b10; // Note: We will use direction to distinguish
localparam SPLATTERED = 2'b11; // Note: This will be handled in the always block

// Output logic
assign walk_left = (current_state == IDLE_LEFT || (current_state == IDLE_RIGHT && dig_signal)) ? 1'b1 : 1'b0;
assign walk_right = (current_state == IDLE_RIGHT && !dig_signal) ? 1'b1 : 1'b0;
assign aaah = (current_state == FALLING) ? 1'b1 : 1'b0;
assign digging = (dig_signal) ? 1'b1 : 1'b0;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= IDLE_LEFT;
        direction <= 0; // Left
        dig_signal <= 1'b0;
        fall_count <= 5'b0;
    end else begin
        case(current_state)
            IDLE_LEFT: begin
                if(!ground) begin
                    current_state <= FALLING;
                    fall_count <= 1;
                end else if(dig) begin
                    current_state <= DIGGING_LEFT;
                    dig_signal <= 1'b1;
                end else if(bump_left) begin
                    current_state <= IDLE_RIGHT;
                    direction <= 1; // Right
                end else if(bump_right) begin
                    // No change needed, already walking left
                end
            end
            IDLE_RIGHT: begin
                if(!ground) begin
                    current_state <= FALLING;
                    fall_count <= 1;
                end else if(dig) begin
                    current_state <= DIGGING_RIGHT;
                    dig_signal <= 1'b1;
                end else if(bump_right) begin
                    current_state <= IDLE_LEFT;
                    direction <= 0; // Left
                end else if(bump_left) begin
                    // No change needed, already walking right
                end
            end
            FALLING: begin
                if(ground) begin
                    if(fall_count > 20) begin
                        current_state <= SPLATTERED;
                    end else begin
                        if(dig_signal) begin
                            dig_signal <= 1'b0;
                        end
                        if(direction == 0) begin
                            current_state <= IDLE_LEFT;
                        end else begin
                            current_state <= IDLE_RIGHT;
                        end
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            DIGGING_LEFT, DIGGING_RIGHT: begin
                if(!ground) begin
                    current_state <= FALLING;
                    dig_signal <= 1'b0;
                    fall_count <= 1;
                end else if(!dig) begin
                    dig_signal <= 1'b0;
                    if(direction == 0) begin
                        current_state <= IDLE_LEFT;
                    end else begin
                        current_state <= IDLE_RIGHT;
                    end
                end
            end
            default: begin // SPLATTERED
                current_state <= SPLATTERED;
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                digging <= 1'b0;
            end
        endcase
    end
end

endmodule