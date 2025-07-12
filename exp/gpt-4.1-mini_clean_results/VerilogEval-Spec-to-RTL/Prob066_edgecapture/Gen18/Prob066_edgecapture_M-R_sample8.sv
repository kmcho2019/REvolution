module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;
    wire [31:0] falling_edge;

    // Capture delayed input for edge detection
    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= 32'b0;
        end else begin
            delayed_in <= in;
        end
    end

    // Combinationally detect falling edges: delayed_in=1 and in=0
    assign falling_edge = delayed_in & ~in;

    // Latch falling edge flags in out register until reset
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | falling_edge;
        end
    end

endmodule