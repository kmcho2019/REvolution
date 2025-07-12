module TopModule(
    input               clk,
    input               reset,
    input  [31:0]       in,
    output reg [31:0]   out
);

reg [31:0] prev_in; // To store the previous input value

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0; // Reset the output register
        prev_in <= 32'd0; // Reset the previous input value
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1'b1 && in[i] == 1'b0) begin
                out[i] <= 1'b1; // Set the output bit if transition from 1 to 0 is detected
            end
        end
        prev_in <= in; // Update the previous input value
    end
end

endmodule