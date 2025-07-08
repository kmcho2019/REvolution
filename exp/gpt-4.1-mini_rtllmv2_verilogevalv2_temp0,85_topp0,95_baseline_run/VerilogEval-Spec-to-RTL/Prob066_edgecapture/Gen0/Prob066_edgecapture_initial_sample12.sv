module TopModule(
    input        clk,
    input        reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            // Detect falling edge: previous bit was 1 and current bit is 0
            out <= out | (prev_in & ~in);
        end
    end

endmodule