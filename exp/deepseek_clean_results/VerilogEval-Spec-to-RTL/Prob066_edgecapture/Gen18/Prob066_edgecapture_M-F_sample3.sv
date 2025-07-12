module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] edge_detect;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            // Explicit falling edge detection
            edge_detect <= prev_in & ~in;
            // Maintain sticky output using explicit OR
            out <= out | edge_detect;
            // Update previous input register
            prev_in <= in;
        end
    end

endmodule