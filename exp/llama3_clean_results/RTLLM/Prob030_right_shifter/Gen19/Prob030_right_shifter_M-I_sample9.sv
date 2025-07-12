module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0
initial q = 8'd0;

// Clock gating signal
reg clk_gated;

// Generate clock gating signal
always @(posedge clk) begin
    if (d!== q[7]) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Update q on each rising edge of the gated clock
always @(posedge clk_gated) begin
    // Directly assign the shifted value to q
    q <= {d, q[7:1]};
end

endmodule