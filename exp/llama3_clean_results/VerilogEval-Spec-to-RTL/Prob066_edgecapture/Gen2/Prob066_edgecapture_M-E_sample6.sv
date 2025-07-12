module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;
reg [31:0] captured;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0;
        captured <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Check for transition from 1 to 0 in the input
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 0 && prev_in[i] == 1 && !captured[i]) begin
                out_reg[i] <= 1'b1;  // Set out_reg to 1 on transition from 1 to 0
                captured[i] <= 1'b1;  // Mark bit as captured
            end
        end
        // Update previous input after the comparison
        prev_in <= in;
    end
end

assign out = out_reg;

endmodule