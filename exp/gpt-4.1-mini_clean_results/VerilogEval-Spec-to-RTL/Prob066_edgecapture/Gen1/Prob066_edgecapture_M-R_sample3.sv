module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    // Register previous input
    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
        end
    end

    // Update output based on previous input and current input
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            // Capture bits that transitioned from 1 to 0
            out <= out | (prev_in & ~in);
        end
    end

endmodule