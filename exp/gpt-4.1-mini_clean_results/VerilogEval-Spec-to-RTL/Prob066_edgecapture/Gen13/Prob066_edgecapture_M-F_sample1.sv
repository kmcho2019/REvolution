module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges: bits that were 1 previously and now 0
            out <= out | (prev_in & ~in);
            // Store current input for next cycle comparison
            prev_in <= in;
        end
    end

endmodule