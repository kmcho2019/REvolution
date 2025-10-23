module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] prev_prev_in;

    always @(posedge clk) begin
        prev_prev_in <= prev_in;  // Two cycles ago
        prev_in <= in;           // One cycle ago
        anyedge <= prev_in ^ prev_prev_in;  // Registered edge detection
    end

endmodule