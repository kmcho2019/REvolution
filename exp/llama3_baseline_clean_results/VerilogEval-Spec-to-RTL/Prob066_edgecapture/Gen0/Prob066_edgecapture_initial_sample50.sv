module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in; // Internal register to store previous input vector

always @ (posedge clk) begin
    if (reset) begin
        // Synchronous reset: clear output register
        out <= 32'd0;
    end else begin
        // Check for change from 1 to 0 in input vector
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                // Set corresponding bit in output register to 1
                out[i] <= 1'b1;
            end
        end
        // Update previous input vector
        prev_in <= in;
    end
end

endmodule