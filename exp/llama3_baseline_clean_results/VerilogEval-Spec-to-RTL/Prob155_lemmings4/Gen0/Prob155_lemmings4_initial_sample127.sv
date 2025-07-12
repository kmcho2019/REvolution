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

    // Define states
    reg [2:0] state;
    localparam WALKING_LEFT = 3'b001;
    localparam WALKING_RIGHT = 3'b010;
    localparam FALLING = 3'b011;
    localparam DIGGING = 3'b100;
    localparam SPLATTERED = 3'b111;

    // Define counter for falling duration
    reg [5:0] fall_counter;

    // Initialize state and counter
    initial begin
        state = WALKING_LEFT;
        fall_counter = 6'd0;
    end

    // Asynchronous reset
    always @(posedge areset) begin
        state = WALKING_LEFT;
        fall_counter = 6'd0;
    end

    // Sequential logic
    always @(posedge clk) begin
        case(state)
            WALKING_LEFT: begin
                if (!ground) begin
                    state = FALLING;
                end else if (dig) begin
                    state = DIGGING;
                end else if (bump_left) begin
                    state = WALKING_RIGHT;
                end else if (bump_right) begin
                    // do nothing
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    state = FALLING;
                end else if (dig) begin
                    state = DIGGING;
                end else if (bump_right) begin
                    state = WALKING_LEFT;
                end else if (bump_left) begin
                    // do nothing
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        state = SPLATTERED;
                    end else begin
                        if (state == WALKING_LEFT) begin
                            state = WALKING_LEFT;
                        end else begin
                            state = WALKING_RIGHT;
                        end
                    end
                end else begin
                    fall_counter = fall_counter + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    state = FALLING;
                end else begin
                    // do nothing
                end
            end
            default: begin
                // do nothing
            end
        endcase
    end

    // Combinational logic for outputs
    always @(*) begin
        case(state)
            WALKING_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            WALKING_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule