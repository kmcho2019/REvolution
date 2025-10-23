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

    // State encoding: [0]=direction (0=right, 1=left), [1:0]=action
    reg [1:0] state;  // state[1:0]: 00=walking, 01=falling, 10=digging

    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b10; // Start walking left (state[1]=1, state[0]=0)
        end else begin
            case (state[0] ? 2'b01 : state) // Check action bits
                // Walking state
                2'b00, 2'b10: begin
                    if (~ground) begin
                        state[0] <= 1'b1; // Start falling
                    end else if (dig & ~state[1]) begin
                        state <= 2'b10; // Start digging
                    end else if (bump_left | bump_right) begin
                        // Toggle direction if bumped
                        state[1] <= (bump_left) ? 1'b0 : 
                                   (bump_right) ? 1'b1 : 
                                   state[1];
                    end
                end
                // Falling state
                2'b01: begin
                    if (ground) begin
                        state[0] <= 1'b0; // Stop falling
                    end
                end
                // Digging state
                2'b10: begin
                    if (~ground) begin
                        state <= 2'b01; // Start falling
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (state == 2'b10);
    assign walk_right = (state == 2'b00);
    assign aaah = state[0];
    assign digging = (state == 2'b10);

endmodule