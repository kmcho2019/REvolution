module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State definitions
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    // Direction definitions
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;
    reg direction;
    reg [2:0] outputs;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= LEFT;
        end
        else begin
            case (state)
                WALK: begin
                    if (!ground) begin
                        state <= FALL;
                    end
                    else if ((bump_left && (direction == LEFT)) || 
                             (bump_right && (direction == RIGHT))) begin
                        direction <= ~direction;
                    end
                end
                FALL: begin
                    if (ground) begin
                        state <= WALK;
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            WALK: begin
                aaah = 1'b0;
                walk_left = (direction == LEFT);
                walk_right = (direction == RIGHT);
            end
            FALL: begin
                aaah = 1'b1;
                walk_left = 1'b0;
                walk_right = 1'b0;
            end
            default: begin
                aaah = 1'b0;
                walk_left = 1'b0;
                walk_right = 1'b0;
            end
        endcase
    end

endmodule