module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    // On each clock cycle, detect edges by XORing current input with previous input.
    // Then store current input as previous input for next cycle.
    always @(posedge clk) begin
        edge_detected <= in ^ prev_in;
        prev_in <= in;
    end

    // Output the registered edge detection from previous cycle, asserting anyedge
    // exactly one cycle after input change.
    assign anyedge = edge_detected;

endmodule