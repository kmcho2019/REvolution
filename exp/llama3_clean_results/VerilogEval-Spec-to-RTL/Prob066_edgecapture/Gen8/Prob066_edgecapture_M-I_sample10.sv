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
        out <= out; // Default: keep the current value
        for (int i = 0; i < 32; i++) begin
            if (~in[i] && prev_in[i]) begin
                out[i] <= 1'b1; // Set to 1 if transition from 1 to 0 detected
            end
        end
    end
end

endmodule