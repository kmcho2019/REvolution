module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in_reg = 32'b0;
    reg [31:0] captured = 32'b0;

    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in_reg <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Detect falling edges (1->0 transitions) using properly timed previous value
            captured <= captured | (prev_in_reg & ~in);
            // Update previous input register after detection
            prev_in_reg <= in;
        end
    end

endmodule