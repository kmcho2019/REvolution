module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Initialize all registers
    initial begin
        out = 32'b0;
        prev_in = 32'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end
        else begin
            out <= out | (prev_in & ~in);  // Detect and permanently latch falling edges
            prev_in <= in;
        end
    end

endmodule