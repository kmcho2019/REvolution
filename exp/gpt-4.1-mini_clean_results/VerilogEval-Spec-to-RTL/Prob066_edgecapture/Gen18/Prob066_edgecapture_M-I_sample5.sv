module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;
    wire        out_load_en;

    // Detect falling edge: bit was 1 and now 0
    assign falling_edge = prev_in & ~in;

    // Enable updating out register only when new falling edges are detected
    assign out_load_en = |falling_edge;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_in <= in;
            // Update out only if falling edges are detected to reduce unnecessary toggling
            if (out_load_en)
                out <= out | falling_edge;
        end
    end

endmodule