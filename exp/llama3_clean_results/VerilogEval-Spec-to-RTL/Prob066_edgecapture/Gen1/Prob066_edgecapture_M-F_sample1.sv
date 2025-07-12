module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        // Keep track of previous input for transition detection
        reg [31:0] curr_in = prev_in;  // Store previous input in a temporary variable
        prev_in <= in;  // Update previous input for next cycle

        // Check for transition from 1 to 0 in the input and update out_reg
        for (int i = 0; i < 32; i++) begin
            if (in[i] == 0 && curr_in[i] == 1) begin
                out_reg[i] <= 1'b1;  // Set out_reg to 1 on transition from 1 to 0
            end
        end
    end
end

assign out = out_reg;

endmodule