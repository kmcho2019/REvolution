module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Internal signals for the Johnson counter
reg [3:0] johnson_counter;

// Always block to update the Johnson counter
always @(posedge clk) begin
    if (reset) begin
        // Reset the Johnson counter to 0
        johnson_counter <= 4'b1000;
    end else begin
        // Shift the bits to the right and invert the last bit
        johnson_counter <= {johnson_counter[2:0], ~johnson_counter[3]};
    end
end

// Continuous assignment to generate the 4-bit binary counter output
assign q = johnson_counter;

endmodule