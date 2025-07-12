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

    // Combined state encoding: [falling, digging, direction]
    // 000: walk left
    // 001: walk right
    // 010: dig left
    // 011: dig right
    // 100: fall left
    // 101: fall right
    // 110: splat (all outputs 0)
    reg [2:0] state;
    reg [4:0] fall_counter;

    // Next state logic
    always @(*) begin
        case (state)
            // Walking states
            3'b000, 3'b001: begin
                if (!ground) begin
                    state[2] = 1'b1; // Start falling
                end else if (dig) begin
                    state[1] = 1'b1; // Start digging
                end else if ((state[0] && bump_right) || (!state[0] && bump_left)) begin
                    state[0] = ~state[0]; // Change direction
                end
            end
            
            // Digging states
            3'b010, 3'b011: begin
                if (!ground) begin
                    state[2] = 1'b1; // Start falling
                    state[1] = 1'b0; // Stop digging
                end
            end
            
            // Falling states
            3'b100, 3'b101: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        state = 3'b110; // Splat
                    end else begin
                        state[2] = 1'b0; // Stop falling
                    end
                end
            end
            
            // Splat state
            3'b110: state = 3'b110;
        endcase
    end

    // State update and fall counter
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 3'b000; // Walk left
            fall_counter <= 0;
        end else begin
            state <= state;
            
            // Update fall counter
            if (state[2] && !ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == 3'b000);
    assign walk_right = (state == 3'b001);
    assign aaah = state[2];
    assign digging = state[1];

endmodule