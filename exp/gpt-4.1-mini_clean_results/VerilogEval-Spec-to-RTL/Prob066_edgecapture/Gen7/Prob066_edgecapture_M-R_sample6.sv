module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    wire [31:0] falling_edge;

    // Combinational detection of falling edges: prev_in=1, current in=0
    assign falling_edge = prev_in & ~in;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'hFFFFFFFF;  // Initialize to all ones at reset
            out <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | falling_edge; // Accumulate falling edge detections
        end
    end

endmodule