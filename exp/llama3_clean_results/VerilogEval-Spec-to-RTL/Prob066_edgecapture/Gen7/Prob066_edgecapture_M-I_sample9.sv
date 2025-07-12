module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        prev_in <= in; // Update prev_in first
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin // Correct comparison
                out[i] <= 1'b1; // Set out[i] to 1 on transition
            end else if (!prev_in[i] && in[i]) begin
                out[i] <= 1'b0; // Reset out[i] to 0 if in[i] is now 1
            end
        end
    end
end

endmodule