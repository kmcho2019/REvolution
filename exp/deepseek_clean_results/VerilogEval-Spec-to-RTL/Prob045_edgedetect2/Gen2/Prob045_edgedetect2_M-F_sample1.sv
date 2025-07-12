module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;            // Store previous input
        anyedge <= in ^ prev_in;  // Detect edges between current and previous
    end

endmodule