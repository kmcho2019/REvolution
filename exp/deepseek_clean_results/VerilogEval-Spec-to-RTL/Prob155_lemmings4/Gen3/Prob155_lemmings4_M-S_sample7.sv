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

    // States
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    parameter SPLAT = 1'b1; // Shared encoding with FALL but differentiated by counter
    
    reg state;          // 0=WALK, 1=FALL/SPLAT
    reg dir;            // 0=left, 1=right
    reg [4:0] counter;  // Fall counter
    reg digging_reg;    // Track if we're digging

    // State transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            dir <= 0;
            counter <= 0;
            digging_reg <= 0;
        end else if (state != SPLAT) begin
            if (~ground) begin
                // Fall has highest priority
                state <= FALL;
                counter <= counter + 1;
                digging_reg <= 0;
            end else if (state == WALK) begin
                if (dig) begin
                    digging_reg <= 1;
                end else if (~digging_reg) begin
                    // Direction change only when not digging
                    if (bump_left) dir <= 1;
                    if (bump_right) dir <= 0;
                end
            end
            
            // Handle ground return from FALL
            if (state == FALL && ground) begin
                state <= (counter > 20) ? SPLAT : WALK;
                counter <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == WALK) & ~dir & ~digging_reg & ~SPLAT;
    assign walk_right = (state == WALK) & dir & ~digging_reg & ~SPLAT;
    assign aaah = (state == FALL);
    assign digging = digging_reg & ground & (state == WALK);

endmodule