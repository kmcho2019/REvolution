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

    // State encoding with direction
    parameter WL = 2'b00;  // Walk left
    parameter WR = 2'b01;  // Walk right
    parameter FALL = 2'b10;
    parameter DIGGING = 2'b11;
    parameter SPLAT = 3'b100;  // Extra bit for splat state
    
    reg [2:0] state;
    reg [4:0] fall_count;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_count <= 0;
        end else begin
            case (state)
                WL, WR: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_count <= 1;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                    end else begin
                        // Handle direction changes
                        if (state == WL && (bump_left || (bump_left && bump_right))) 
                            state <= WR;
                        else if (state == WR && (bump_right || (bump_left && bump_right)))
                            state <= WL;
                    end
                end
                
                FALL: begin
                    if (ground) begin
                        state <= (fall_count > 20) ? SPLAT : (state[0] ? WR : WL);
                        fall_count <= 0;
                    end else begin
                        fall_count <= fall_count + 1;
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALL;
                        fall_count <= 1;
                    end
                end
                
                SPLAT: begin
                    // Stay in splat state
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FALL);
    assign digging = (state == DIGGING);

endmodule