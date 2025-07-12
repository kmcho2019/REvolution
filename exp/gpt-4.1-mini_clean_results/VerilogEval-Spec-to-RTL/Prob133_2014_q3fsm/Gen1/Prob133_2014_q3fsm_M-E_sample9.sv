module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding:
    // state[2:1] = cycle count (0 to 3)
    // state[0] = w count parity bit is not enough; so we encode cycle count and w count together
    // To track both cycle count (0..3) and w_count (0..3), we can use a 3-bit register where:
    // - lower 2 bits: w_count (0..3)
    // - upper bit: cycle count MSB plus cycle count LSB stored separately:
    // Instead, use a 4-bit register: 2 bits cycle count + 2 bits w_count
    // Let's implement 4-bit state: bits[3:2] = cycle_count (0..3), bits[1:0] = w_count (0..3)
    // State=4'b0000 means we are in A (waiting for s=1)
    // Any other state means we are in B counting cycles and w_count.

    reg [3:0] state, next_state;
    // state format:
    // [3:2] cycle_count: 2 bits (0 to 3)
    // [1:0] w_count: 2 bits (0 to 3)

    wire in_A = (state == 4'b0000);
    wire in_B = !in_A;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z logic:
            // When cycle_count reaches 3 (state[3:2] == 2'b11), we output z based on w_count from previous cycle.
            // Since state is updated on posedge clk, we compute z from previous state:
            if (in_B && state[3:2] == 2'b11) begin
                // Exactly 3 cycles counted, output z=1 if w_count == 2 else 0
                z <= (state[1:0] == 2'b10) ? 1'b1 : 1'b0;
            end else begin
                // Otherwise output 0
                z <= 1'b0;
            end
        end
    end

    always @(*) begin
        if (reset) begin
            next_state = 4'b0000; // back to A
        end else begin
            if (in_A) begin
                // In state A, wait for s=1 to move to B
                if (s) begin
                    // Move to cycle_count=1, w_count= w ? 1 : 0
                    next_state[3:2] = 2'b01; // cycle_count = 1
                    next_state[1:0] = w ? 2'b01 : 2'b00;
                end else begin
                    next_state = 4'b0000; // stay in A
                end
            end else begin
                // In B:
                // Extract current cycle_count and w_count
                reg [1:0] cycle_count = state[3:2];
                reg [1:0] w_count = state[1:0];
                if (cycle_count == 2'b11) begin
                    // Last cycle in group of 3 completed
                    // Start new counting: cycle_count=1, w_count= w?1:0
                    next_state[3:2] = 2'b01;
                    next_state[1:0] = w ? 2'b01 : 2'b00;
                end else begin
                    // Increment cycle_count and add w to w_count
                    next_state[3:2] = cycle_count + 1;
                    // Add w to w_count, saturate at 3 (max count)
                    if (w) begin
                        if (w_count == 2'b11)
                            next_state[1:0] = 2'b11;
                        else
                            next_state[1:0] = w_count + 1;
                    end else begin
                        next_state[1:0] = w_count;
                    end
                end
            end
        end
    end

endmodule