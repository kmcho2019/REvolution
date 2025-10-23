module counter_12(
    input rst_n,    // Reset signal (active low)
    input clk,      // Clock signal
    input valid_count, // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out_reg; // Internal register for output

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        out_reg <= 4'b0000; // Reset output register to 0
    end else if (valid_count) begin // Counting condition
        if (out_reg == 4'd11) begin // Wrap around condition
            out_reg <= 4'b0000; // Reset output register to 0
        end else begin
            out_reg <= out_reg + 1; // Increment output register
        end
    end
end

assign out = out_reg; // Assign output register to output port

endmodule