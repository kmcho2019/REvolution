module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            // Detect falling edges: previous bit=1 and current bit=0
            out <= out | (prev_in & ~in);
        end
    end

endmodule