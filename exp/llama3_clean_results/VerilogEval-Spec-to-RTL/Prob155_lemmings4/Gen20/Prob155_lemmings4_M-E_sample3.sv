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

// State machine states
localparam WALKING = 2'b00;
localparam FALLING = 2'b01;
localparam SPLATTERED = 2'b10;

reg [1:0] state;
reg [1:0] walk_substate;
reg [4:0] fall_counter;
reg digging_on;

// State machine
always @(posedge clk) begin
    if (areset) begin
        state <= WALKING;
        walk_substate <= 2'b0; // WALK_LEFT
        fall_counter <= 5'b0;
        digging_on <= 1'b0;
    end else begin
        case (state)
            WALKING: begin
                case (walk_substate)
                    2'b0: begin // WALK_LEFT
                        if (bump_left || (bump_right && !bump_left)) begin
                            walk_substate <= 2'b1; // WALK_RIGHT
                        end else if (dig && ground) begin
                            walk_substate <= 2'b10; // DIGGING
                            digging_on <= 1'b1;
                        end else if (!ground) begin
                            state <= FALLING;
                        end
                    end
                    2'b1: begin // WALK_RIGHT
                        if (bump_right || (bump_left && !bump_right)) begin
                            walk_substate <= 2'b0; // WALK_LEFT
                        end else if (dig && ground) begin
                            walk_substate <= 2'b10; // DIGGING
                            digging_on <= 1'b1;
                        end else if (!ground) begin
                            state <= FALLING;
                        end
                    end
                    2'b10: begin // DIGGING
                        if (!ground) begin
                            state <= FALLING;
                            digging_on <= 1'b0;
                        end
                    end
                endcase
            end
            FALLING: begin
                fall_counter <= fall_counter + 1'b1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        state <= SPLATTERED;
                    end else begin
                        state <= WALKING;
                        walk_substate <= walk_substate; // maintain previous direction
                    end
                    fall_counter <= 5'b0;
                end
            end
            SPLATTERED: begin
                // do nothing
            end
        endcase
    end
end

// Combinational logic for outputs
always @(*) begin
    case (state)
        WALKING: begin
            case (walk_substate)
                2'b0: begin
                    walk_left = 1'b1;
                    walk_right = 1'b0;
                end
                2'b1: begin
                    walk_left = 1'b0;
                    walk_right = 1'b1;
                end
                2'b10: begin
                    walk_left = 1'b0;
                    walk_right = 1'b0;
                end
            endcase
            aaah = 1'b0;
            digging = digging_on;
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
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