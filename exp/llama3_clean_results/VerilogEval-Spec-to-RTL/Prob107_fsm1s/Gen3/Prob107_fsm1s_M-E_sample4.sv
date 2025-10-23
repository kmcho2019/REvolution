module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the lookup table
reg [1:0] lut_ns [1:0]; // Next state LUT
reg [0:0] lut_out [1:0]; // Output LUT

// Initialize the LUTs
initial begin
    lut_ns[1] = 2'b01; // State B, in = 0 -> Next State A
    lut_ns[0] = 2'b11; // State B, in = 1 -> Next State B
    lut_ns[1] = 2'b11; // State A, in = 0 -> Next State B
    lut_ns[0] = 2'b01; // State A, in = 1 -> Next State A
    lut_out[1] = 1'b1; // State B, out = 1
    lut_out[0] = 1'b0; // State A, out = 0
end

// State Register
reg [0:0] state;
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b1; // Reset state is B
    end else begin
        // Use the LUT to determine the next state
        if (in) begin
            state <= lut_ns[1];
        end else begin
            state <= lut_ns[0];
        end
    end
end

// Output Logic
always_comb begin
    // Use the LUT to determine the output
    if (state) begin
        out = lut_out[1];
    end else begin
        out = lut_out[0];
    end
end

endmodule