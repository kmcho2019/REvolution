module TopModule (
    input         clk,
    input         reset,
    input  [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize prev_in to current input to avoid false detection at first cycle after reset
            prev_in <= in;
            out <= 32'b0;
        end else begin
            // Capture falling edges: bits that were 1 in prev_in and now 0 in in
            out <= out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule