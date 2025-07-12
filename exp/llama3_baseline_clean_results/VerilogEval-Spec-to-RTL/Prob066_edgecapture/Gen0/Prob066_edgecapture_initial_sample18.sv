module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;  // Register to store previous input
reg [31:0] out_reg; // Register to store output

always @(posedge clk) begin
    if (reset) begin
        // Reset output register
        out_reg <= 32'd0;
    end else begin
        // Store current input for next cycle
        prev_in <= in;
        
        // Check for transitions from 1 to 0
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                // Set output bit if transition detected
                out_reg[i] <= 1'b1;
            end
        end
    end
end

assign out = out_reg;

endmodule