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

    reg [1:0] state;
    reg [4:0] fall_count;

    // Define states
    parameter IDLE_LEFT = 2'b00;
    parameter IDLE_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;
    parameter SPLATTERED = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
            fall_count <= 0;
        end else begin
            case (state)
                IDLE_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_count <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_left) begin
                        state <= IDLE_RIGHT;
                    end else if (bump_right) begin
                        state <= IDLE_LEFT;
                    end
                end
                IDLE_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_count <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_left) begin
                        state <= IDLE_LEFT;
                    end else if (bump_right) begin
                        state <= IDLE_RIGHT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        if (fall_count > 20) begin
                            state <= SPLATTERED;
                        end else if (dig) begin
                            // ignore dig when falling
                            state <= IDLE_LEFT;
                        end else begin
                            state <= IDLE_LEFT;
                        end
                        fall_count <= 0;
                    end else begin
                        fall_count <= fall_count + 1;
                    end
                end
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_count <= 1;
                    end else if (!dig) begin
                        state <= IDLE_LEFT;
                    end
                end
                SPLATTERED: begin
                    // stay in splattered state forever
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE_LEFT: begin
                walk_left = 1'b1;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
            IDLE_RIGHT: begin
                walk_left = 1'b0;
                walk_right = 1'b1;
                aaah = 1'b0;
                digging = 1'b0;
            end
            FALLING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b1;
                digging = 1'b0;
            end
            DIGGING: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b1;
            end
            SPLATTERED: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end
endmodule