module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    reg        prev_valid;

    always @(posedge clk) begin
        if (reset) begin
            out        <= 32'b0;
            prev_in    <= 32'b0;
            prev_valid <= 1'b0;
        end else begin
            if (prev_valid) begin
                // Detect falling edges: bit was 1 previously and now 0
                out <= out | (prev_in & ~in);
            end
            prev_in    <= in;
            prev_valid <= 1'b1;
        end
    end

endmodule