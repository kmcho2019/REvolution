module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg; // Output register
reg [31:0] prev_in; // Previous input register

// Initialize out_reg and prev_in to all zeros to avoid false transitions at power-up or reset
initial begin
    out_reg = 32'b0;
    prev_in = 32'b0;
end

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'b0;
        prev_in <= 32'b0; // Reset previous input to zero
    end else begin
        // Detect transitions from 1 to 0 and set output bits accordingly
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] &&!in[i]) begin
                out_reg[i] <= 1'b1; // Set output bit if transition detected
            end
        end
        // Update previous input
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule