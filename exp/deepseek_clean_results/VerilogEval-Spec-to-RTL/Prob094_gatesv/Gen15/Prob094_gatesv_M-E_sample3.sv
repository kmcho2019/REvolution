module TopModule (
    input clk,            // Added clock for sequential processing
    input [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    reg [3:0] shift_reg;
    reg [1:0] cycle;
    wire current_bit, left_bit, right_bit;

    // Shift register with wrap-around
    always @(posedge clk) begin
        if (cycle == 0) shift_reg <= in;  // Load input
        else shift_reg <= {shift_reg[0], shift_reg[3:1]};  // Rotate right
    end

    // Cycle counter
    always @(posedge clk) begin
        cycle <= (cycle == 3) ? 0 : cycle + 1;
    end

    // Current bit and neighbors
    assign current_bit = shift_reg[0];
    assign left_bit = shift_reg[1];  // Left neighbor (higher index)
    assign right_bit = shift_reg[3]; // Right neighbor (lower index, wraps around)

    // Processing logic
    always @(posedge clk) begin
        if (cycle != 0) begin  // Skip cycle 0 (loading)
            // out_both (current AND left)
            if (cycle < 3) out_both[cycle] <= current_bit & left_bit;

            // out_any (current OR right)
            if (cycle > 0) out_any[cycle] <= current_bit | right_bit;

            // out_different (current XOR left)
            out_different[cycle] <= current_bit ^ left_bit;
        end
    end

    // Initialize unused bits
    initial begin
        out_both[3] = 0;
        out_any[0] = 0;
    end

endmodule