module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        edge_detected <= in ^ prev_in;  // Detect edges on current cycle
        prev_in <= in;                  // Store current input for next cycle
        anyedge <= edge_detected;       // Output edge detected on previous cycle
    end

endmodule