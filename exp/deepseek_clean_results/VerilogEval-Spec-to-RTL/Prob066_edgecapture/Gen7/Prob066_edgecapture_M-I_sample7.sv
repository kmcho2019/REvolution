module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_prev;  // Previous input value

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            in_prev <= 32'b0;
        end
        else begin
            // Store current input for next cycle comparison
            in_prev <= in;
            
            // Detect falling edges and capture them (hold until reset)
            out <= out | (in_prev & ~in);
        end
    end

endmodule