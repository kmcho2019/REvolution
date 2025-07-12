module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] prev_in_delayed;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
            prev_in_delayed <= 32'b0;
        end
        else begin
            // Stage 1: Store current input
            prev_in <= in;
            // Stage 2: Store previous cycle's input for comparison
            prev_in_delayed <= prev_in;
            // Detect falling edges using properly delayed values
            out <= out | (prev_in_delayed & ~in);
        end
    end

endmodule