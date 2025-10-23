module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding:
    // state=0: before first '1' encountered (copy input)
    // state=1: after first '1' encountered (invert input)
    reg state, next_state;

    // Registered output bit of Moore FSM, depends only on state
    reg out_bit, next_out_bit;

    // Combinational logic to determine next state and next output bit
    // Moore output bit is 0 in state 0 (no inversion), 1 in state 1 (invert)
    always @(*) begin
        // Default assignments
        next_state = state;
        next_out_bit = out_bit;

        case (state)
            1'b0: begin
                // Before first '1' encountered
                // Output bit is 0 => output = x ^ 0 = x (copy input)
                if (x == 1'b1) begin
                    next_state = 1'b1;
                    next_out_bit = 1'b1; // after first 1, invert bits
                end else begin
                    next_state = 1'b0;
                    next_out_bit = 1'b0;
                end
            end
            1'b1: begin
                // After first '1' encountered
                // Output bit is 1 => output = x ^ 1 = ~x (invert input)
                next_state = 1'b1;
                next_out_bit = 1'b1;
            end
            default: begin
                next_state = 1'b0;
                next_out_bit = 1'b0;
            end
        endcase
    end

    // Sequential logic: register state and output bit with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            out_bit <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            out_bit <= next_out_bit;
            // Output is Moore output bit XOR input
            // But output must be registered and depend only on state
            // So output = out_bit XOR x delayed by 1 clock cycle would be Mealy
            // To maintain Moore output, output is registered separately here:
            z <= (next_out_bit) ^ x; // Actually this would be Mealy again
            // To strictly keep Moore FSM: output must be registered version of out_bit only
            // But output is defined as 2's complement output bit by bit, so output = x ^ out_bit
            // So, to keep Moore: output latency of 1 cycle is necessary:
            // We'll delay x by one cycle and XOR with out_bit registered

            // Implement a registered delayed input x_d
        end
    end

    // Register input x to synchronize with output latency
    reg x_d;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_d <= 1'b0;
        end else begin
            x_d <= x;
        end
    end

    // Final output assignment after registering input and output bit
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            // output = x_d XOR out_bit (Moore output)
            z <= x_d ^ out_bit;
        end
    end

endmodule