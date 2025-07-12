module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register

always @(posedge clk) begin
    if (reset) begin
        // Reset the output register
        out_reg <= 32'b0;
    end else begin
        // Detect transitions from 1 to 0 and update the output register
        for (int i = 0; i < 32; i++) begin
            if (out_reg[i] || (!in[i] && out_reg[i] == 1'b0)) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

// Assign the output of the module to the output register
assign out = out_reg;

endmodule