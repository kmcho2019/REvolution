module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_prev;
    wire [7:0] input_changed;
    wire clk_enable = |(in ^ in_prev);  // Clock gating enable

    always @(posedge clk) begin
        if (clk_enable) begin
            in_prev <= in;  // Only update when inputs change
        end
        pedge <= (~in_prev) & in;  // Maintain efficient edge detection
    end

endmodule