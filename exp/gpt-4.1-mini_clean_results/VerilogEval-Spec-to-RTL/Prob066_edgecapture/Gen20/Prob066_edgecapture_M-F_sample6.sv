module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Detect falling edge: bit was 1 and now 0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;   // Initialize prev_in to current input to avoid false edges after reset
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge;  // Capture any new falling edges
        end
    end

endmodule