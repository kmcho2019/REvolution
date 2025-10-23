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

    // State encoding:
    // [2]   - direction (1=left, 0=right)
    // [1:0] - action state:
    //   00 - WALKING
    //   01 - DIGGING
    //   10 - FALLING
    reg [2:0] state;

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 3'b100; // Start walking left
        end else begin
            case (state[1:0])
                2'b00: begin // WALKING
                    if (~ground) begin
                        state <= {state[2], 2'b10}; // Start falling
                    end else if (dig) begin
                        state <= {state[2], 2'b01}; // Start digging
                    end else if (bump_left || bump_right) begin
                        // Handle direction change
                        if (bump_left && bump_right)
                            state[2] <= ~state[2];
                        else if (bump_left)
                            state[2] <= 1'b0;
                        else if (bump_right)
                            state[2] <= 1'b1;
                    end
                end
                2'b01: begin // DIGGING
                    if (~ground) begin
                        state <= {state[2], 2'b10}; // Fall when ground disappears
                    end
                end
                2'b10: begin // FALLING
                    if (ground) begin
                        state <= {state[2], 2'b00}; // Return to walking when ground reappears
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state[2] & (state[1:0] == 2'b00));
    assign walk_right = (~state[2] & (state[1:0] == 2'b00));
    assign aaah = (state[1:0] == 2'b10);
    assign digging = (state[1:0] == 2'b01);

endmodule