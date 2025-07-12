module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // State registers:
    // current_state: 513 bits (512 bits + 1 zero appended at MSB for left boundary)
    // next_state: stores next generation being built bit by bit
    reg [512:0] current_state; // bits [512:0]; current_state[512] = left boundary bit (always 0)
    reg [511:0] next_state;

    // Index to track which cell is being processed (0..511)
    reg [8:0] idx; // 9 bits to hold 0 to 512

    // Combinational logic to compute next bit based on Rule 110 truth table:
    // Inputs: left = current_state[idx+1], center = current_state[idx], right = current_state[idx-1]
    // Boundaries: current_state[512] = 0 (left boundary),
    //             current_state[-1] (not available) assumed 0, so we read current_state[0] for idx=0 safely.
    // Note idx runs 0 to 511; idx-1 must be handled carefully at idx=0.

    wire left_bit;
    wire center_bit;
    wire right_bit;

    assign left_bit   = current_state[idx+1];            // left neighbor
    assign center_bit = current_state[idx];
    assign right_bit  = (idx == 0) ? 1'b0 : current_state[idx-1]; // right neighbor or zero if idx=0

    // Apply Rule 110:
    // next = (~left & center) | (center ^ right)
    wire next_bit = (~left_bit & center_bit) | (center_bit ^ right_bit);

    // Sequential logic:
    always @(posedge clk) begin
        if (load) begin
            // Load input data, reset index, zero-extend left boundary bit
            current_state <= {1'b0, data};
            next_state <= 512'b0;
            idx <= 0;
            q <= data;
        end else begin
            if (idx < 512) begin
                // Shift the newly computed bit into next_state from left (MSB) side
                // Build next_state bit by bit from idx=0 to 511
                next_state <= {next_state[510:0], next_bit};
                idx <= idx + 1;
            end else begin
                // After computing all 512 bits next_state is complete
                // Load next_state into current_state with left boundary zero padded
                current_state <= {1'b0, next_state};
                q <= next_state;
                next_state <= 512'b0;
                idx <= 0;
            end
        end
    end

endmodule