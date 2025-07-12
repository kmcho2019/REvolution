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

    // Main states
    localparam [1:0] 
        WALKING = 2'b00,
        FALLING = 2'b01,
        DIGGING = 2'b10,
        SPLATTERED = 2'b11;

    // Direction tracking
    reg direction;  // 0=left, 1=right
    reg [4:0] fall_counter;
    reg [1:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 0;  // Start walking left
            fall_counter <= 0;
        end else begin
            case (state)
                WALKING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else begin
                        // Handle direction changes
                        if (bump_left) direction <= 1;
                        if (bump_right) direction <= 0;
                    end
                end
                
                FALLING: begin
                    if (!ground) begin
                        fall_counter <= fall_counter + 1;
                    end else begin
                        if (fall_counter > 20)
                            state <= SPLATTERED;
                        else
                            state <= WALKING;
                    end
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                    end
                end
                
                SPLATTERED: begin
                    // Stay in splattered state forever
                    state <= SPLATTERED;
                end
            endcase
        end
    end

    // Output logic - pure Moore machine
    assign walk_left = (state == WALKING) && !direction;
    assign walk_right = (state == WALKING) && direction;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule