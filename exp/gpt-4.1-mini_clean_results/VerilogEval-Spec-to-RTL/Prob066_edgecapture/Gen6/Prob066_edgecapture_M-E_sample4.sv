module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] in,
    output reg  [31:0] out
);

    reg [31:0] delayed_in;
    wire [31:0] falling_edge;

    // Falling edge detection: delayed_in=1 and current in=0
    assign falling_edge = delayed_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            delayed_in <= 32'b0;
            out        <= 32'b0;
        end else begin
            delayed_in <= in;
            // Latch falling edge detections
            out <= out | falling_edge;
        end
    end

endmodule