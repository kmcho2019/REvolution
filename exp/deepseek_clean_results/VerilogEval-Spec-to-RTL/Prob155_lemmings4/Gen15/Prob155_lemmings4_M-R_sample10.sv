module TopModule (
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

    // State definitions
    parameter WALKING = 2'b00;
    parameter FALLING = 2'b01;
    parameter DIGGING = 2'b10;
    parameter SPLATTERED = 2'b11;
    
    reg [1:0] state;
    reg move_left;  // 1 = left, 0 = right
    reg [4:0] fall_cycles;

    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            move_left <= 1'b1;
            fall_cycles <= 0;
        end else begin
            case (state)
                WALKING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_cycles <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else begin
                        // Handle direction changes
                        case ({bump_left, bump_right})
                            2'b01: move_left <= 0;
                            2'b10: move_left <= 1;
                            2'b11: move_left <= ~move_left;
                            default: ; // Keep direction
                        endcase
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        state <= (fall_cycles > 20) ? SPLATTERED : WALKING;
                        fall_cycles <= 0;
                    end else begin
                        fall_cycles <= fall_cycles + 1;
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_cycles <= 1;
                    end
                    // Stay in DIGGING while ground=1
                end
                
                SPLATTERED: begin
                    // Stay in SPLATTERED forever
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == WALKING) & move_left;
    assign walk_right = (state == WALKING) & ~move_left;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule