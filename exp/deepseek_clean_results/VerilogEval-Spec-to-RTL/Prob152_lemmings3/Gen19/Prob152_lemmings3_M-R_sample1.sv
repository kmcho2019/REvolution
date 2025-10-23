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

    // State variables
    reg direction;  // 0=left, 1=right
    reg [1:0] mode; // 00=walk, 01=dig, 10=fall

    // Next state logic (continuous assignments)
    wire next_direction;
    wire [1:0] next_mode;

    assign next_mode = (mode == 2'b10) ? (ground ? 2'b00 : 2'b10) :  // Fall state
                     (~ground ? 2'b10 :  // Fall has highest priority
                     (dig && mode == 2'b00 ? 2'b01 :  // Dig if walking
                     2'b00));  // Default to walk

    assign next_direction = (mode == 2'b10) ? direction :  // Keep direction when falling
                          (mode == 2'b01) ? direction :  // Keep direction when digging
                          (bump_left ? 1'b1 :  // Switch to right if bumped left
                          (bump_right ? 1'b0 :  // Switch to left if bumped right
                          direction));  // Otherwise keep direction

    // State update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // Start walking left
            mode <= 2'b00;
        end else begin
            direction <= next_direction;
            mode <= next_mode;
        end
    end

    // Output logic
    assign walk_left = (mode == 2'b00) & ~direction;
    assign walk_right = (mode == 2'b00) & direction;
    assign aaah = (mode == 2'b10);
    assign digging = (mode == 2'b01);

endmodule