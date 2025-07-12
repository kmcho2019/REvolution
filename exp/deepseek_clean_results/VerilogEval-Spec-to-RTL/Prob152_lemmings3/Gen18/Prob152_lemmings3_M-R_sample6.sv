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

    // One-hot state encoding
    parameter WALKING = 2'b01;
    parameter FALLING = 2'b10;
    
    reg [1:0] state;
    reg direction; // 0=left, 1=right
    reg dig_active;

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
        end
        else begin
            case (state)
                WALKING: state <= (!ground) ? FALLING : WALKING;
                FALLING: state <= (ground) ? WALKING : FALLING;
                default: state <= WALKING;
            endcase
        end
    end

    // Direction and dig_active update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
            dig_active <= 0;
        end
        else begin
            case (state)
                WALKING: begin
                    if (ground) begin
                        dig_active <= dig ? 1'b1 : (dig_active & ground);
                        if (!dig_active) begin
                            direction <= (bump_left) ? 1'b1 : 
                                         (bump_right) ? 1'b0 : 
                                         direction;
                        end
                    end
                    else begin
                        dig_active <= 0;
                    end
                end
                FALLING: begin
                    dig_active <= 0;
                end
            endcase
        end
    end

    // Output assignments
    assign walk_left  = (state == WALKING) & ~direction & ~dig_active;
    assign walk_right = (state == WALKING) & direction & ~dig_active;
    assign aaah       = (state == FALLING);
    assign digging    = (state == WALKING) & dig_active;

endmodule