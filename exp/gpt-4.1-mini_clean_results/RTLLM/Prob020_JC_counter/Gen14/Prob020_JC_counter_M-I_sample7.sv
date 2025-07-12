module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low synchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;              // Synchronously reset counter to zero
    end else begin
        // Shift right by 1, MSB gets inverted LSB, implementing Johnson counter logic
        Q <= { ~Q[0], Q[63:1] };
    end
end

endmodule