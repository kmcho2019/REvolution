module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'b0;
        prev_in <= in; // Reset previous input to current input to avoid false transitions at reset
    end else begin
        // Detect transitions from 1 to 0
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_reg[i] <= 1'b1; // Set the corresponding bit in out_reg
            end
        end
        // Update previous input
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule