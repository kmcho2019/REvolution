module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational detection of falling edge: prev_in=1 and in=0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= in;  // Sample input at reset to avoid false edge detections
            out     <= 32'b0;
        end else begin
            prev_in <= in;           // Store current input for next edge detection
            out     <= out | falling_edge;  // Latch falling edges
        end
    end

endmodule