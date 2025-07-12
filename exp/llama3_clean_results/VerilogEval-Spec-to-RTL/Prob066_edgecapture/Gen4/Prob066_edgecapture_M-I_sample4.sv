module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in; // Register to store the previous input
reg [31:0] out_reg; // Register to store the output

always @(posedge clk) begin
    if (reset) begin
        // Reset all registers
        prev_in <= 32'b0;
        out_reg <= 32'b0;
    end else begin
        // Update the previous input register
        prev_in <= in;
        
        // Update the output register based on transition detection
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule