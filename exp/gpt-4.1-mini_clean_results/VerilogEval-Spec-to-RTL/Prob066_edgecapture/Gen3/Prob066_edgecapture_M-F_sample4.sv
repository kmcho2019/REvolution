module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_d;

    always @(posedge clk) begin
        if (reset) begin
            in_d <= 32'b0;
            out <= 32'b0;
        end else begin
            // Detect falling edges by comparing delayed input (in_d) with current input (in)
            // falling edge: in_d = 1, in = 0
            out <= out | (in_d & ~in);
            in_d <= in;
        end
    end

endmodule