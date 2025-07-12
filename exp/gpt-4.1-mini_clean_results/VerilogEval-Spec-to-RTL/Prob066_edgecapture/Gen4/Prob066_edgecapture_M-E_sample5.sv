module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] in_dly;        // Delayed input register to detect edges
    reg [31:0] edge_detected; // Register holding detected falling edges on current cycle

    always @(posedge clk) begin
        if (reset) begin
            in_dly <= 32'b0;
            edge_detected <= 32'b0;
            out <= 32'b0;
        end else begin
            in_dly <= in;
            edge_detected <= in_dly & ~in;  // Detect 1->0 transitions
            out <= out | edge_detected;     // Latch detected edges until reset
        end
    end

endmodule