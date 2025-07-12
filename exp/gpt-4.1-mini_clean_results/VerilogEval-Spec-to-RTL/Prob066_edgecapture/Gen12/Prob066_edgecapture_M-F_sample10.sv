module TopModule (
    input wire clk,
    input wire reset,
    input wire [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            // On synchronous reset, clear output and initialize prev_in to current input to avoid false edge detection
            out <= 32'b0;
            prev_in <= in;
        end else begin
            // Detect falling edges and latch them until reset
            out <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule