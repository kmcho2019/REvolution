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
        // Reset the output register
        out_reg <= 32'b0;
    end else begin
        // Update the output register based on the transition detection
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                out_reg[i] <= 1'b1;
            end else begin
                out_reg[i] <= out_reg[i]; // Keep the current state
            end
        end
    end
end

always @(posedge clk) begin
    // Update the previous input register
    prev_in <= in;
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule