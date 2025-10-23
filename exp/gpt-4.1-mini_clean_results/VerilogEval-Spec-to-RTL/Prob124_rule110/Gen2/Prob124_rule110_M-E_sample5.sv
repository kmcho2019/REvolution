module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Index to scan cells 0..511
    reg [8:0] idx;  // 9 bits needed for 512 values
    reg updating;   // indicates if we are in update mode

    // Temporary storage of q bits for neighbor access
    wire left_bit;
    wire center_bit;
    wire right_bit;

    // Compute neighbors with boundary zero assumption
    assign left_bit   = (idx == 511) ? 1'b0 : q[idx + 1];
    assign center_bit = q[idx];
    assign right_bit  = (idx == 0) ? 1'b0 : q[idx - 1];

    // Rule 110 function as combinational logic expression (simplified)
    // From truth table given:
    // next_state = (!left & center) | (center ^ right) | (left & !center & !right)
    // This is an expression equivalent to Rule 110:
    wire next_cell_state;
    assign next_cell_state =
        (~left_bit & center_bit) |
        (center_bit ^ right_bit) |
        (left_bit & ~center_bit & ~right_bit);

    always @(posedge clk) begin
        if (load) begin
            // Load entire state and reset index
            q <= data;
            idx <= 0;
            updating <= 1'b1; // start updating from next cycle
        end else if (updating) begin
            // Update q[idx] with next state
            q[idx] <= next_cell_state;
            // Increment index and wrap around
            if (idx == 511)
                idx <= 0;  // one full pass done, wrap to zero
            else
                idx <= idx + 1;
        end
        // else hold q as is (no update)
    end

endmodule