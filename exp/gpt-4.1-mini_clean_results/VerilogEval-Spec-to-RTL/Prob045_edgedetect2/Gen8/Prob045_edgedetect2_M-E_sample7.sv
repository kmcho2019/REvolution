module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        prev_in <= in;                    // Store current input for next cycle comparison
        edge_detected <= in ^ prev_in;   // Detect edges in current cycle
        anyedge <= edge_detected;        // Output edge detection delayed by one cycle
    end

endmodule