/**
 * Configurable Shift Register with Parallel Load
 * @param WIDTH Data width (default = 8 bits)
 * @input clk       Clock signal
 * @input reset     Active-high synchronous reset
 * @input load      Load enable (1 = parallel load, 0 = hold/shift)
 * @input shift_in  Serial input for shift operation
 * @input d         Parallel data input
 * @output q        Parallel data output
 * @note Reset has priority and clears all bits synchronously
 */
module ShiftRegisterPL #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input load,
    input shift_in,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end
    else if (load) begin
        q <= d;              // Parallel load
    end
    // else begin            // Shift mode (commented out as unused)
    //     q <= {shift_in, q[WIDTH-1:1]};
    // end
end

endmodule

/**
 * Top Module using Shift Register with Parallel Load
 * @input clk   Clock signal
 * @input reset Active-high synchronous reset
 * @input d     8-bit data input
 * @output q    8-bit data output
 * @note Uses shift register architecture in parallel load mode only
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

ShiftRegisterPL #(.WIDTH(8)) sr_inst (
    .clk(clk),
    .reset(reset),
    .load(1'b1),        // Always in parallel load mode
    .shift_in(1'b0),     // Unused
    .d(d),
    .q(q)
);

endmodule