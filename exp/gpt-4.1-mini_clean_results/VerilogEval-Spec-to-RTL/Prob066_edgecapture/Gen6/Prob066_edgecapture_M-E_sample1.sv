module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] curr_in;

    always @(posedge clk) begin
        if (reset) begin
            curr_in <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges between previous input stage (curr_in) and current input (in)
            // Falling edge: bit was 1 in curr_in and now 0 in in
            out <= out | (curr_in & ~in);

            // Register current input to curr_in for next cycle detection
            curr_in <= in;
        end
    end

endmodule