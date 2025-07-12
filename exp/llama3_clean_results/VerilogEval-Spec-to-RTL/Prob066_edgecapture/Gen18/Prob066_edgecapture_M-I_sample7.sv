module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out = 32'd0
);

reg [31:0] prev_in = 32'd0;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'd0;
        out <= 32'd0;
    end else begin
        prev_in <= in;
        reg [31:0] new_out = out; // Temporary variable to hold new out value
        for (int i = 0; i < 32; i++) begin
            if (~in[i] & prev_in[i]) begin
                new_out[i] = 1'b1; // Set if transition from 1 to 0 detected
            end else if (out[i] == 1'b1) begin
                new_out[i] = 1'b1; // Keep high if previously set
            end else begin
                new_out[i] = 1'b0; // Clear if not previously set and no transition
            end
        end
        if (new_out!= out) begin // Only update out if it has changed
            out <= new_out;
        end
    end
end

endmodule