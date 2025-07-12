module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // Previous input register
reg [31:0] out_reg; // Output register

always @(posedge clk) begin
    if (reset) begin
        // Reset the output register and previous input state
        out_reg <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        // Store the current input vector in the previous input register
        prev_in <= in;
        
        // Update the output register based on the detected transitions
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule