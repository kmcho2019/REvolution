module TopModule(
    input         clk,        // Clock input
    input         resetn,     // Active-low synchronous reset
    input  [1:0]  byteena,    // Byte enable inputs
    input  [15:0] d,         // 16-bit input data
    output [15:0] q          // 16-bit output
);

// Internal register to hold the output value
reg [15:0] q_reg;

// Always block triggered by the positive edge of the clock
always @(posedge clk) begin
    // Check for synchronous reset
    if (~resetn) begin
        // Reset the internal register to zero
        q_reg <= 16'd0;
    end else begin
        // Update the lower byte if byteena[0] is high
        if (byteena[0]) begin
            q_reg[7:0] <= d[7:0];
        end
        // Update the upper byte if byteena[1] is high
        if (byteena[1]) begin
            q_reg[15:8] <= d[15:8];
        end
    end
end

// Continuous assignment to output the value of the internal register
assign q = q_reg;

endmodule