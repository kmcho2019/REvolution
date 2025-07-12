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
        prev_in <= in;
        
        // Update out using a latch-like mechanism
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out[i] <= 1'b1; // Set out[i] if transition from 1 to 0 is detected
            end else if (reset) begin
                out[i] <= 1'b0; // Reset out[i] if reset is asserted
            end
        end
    end
end

endmodule