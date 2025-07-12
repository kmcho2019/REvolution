module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;              // Store current input
        anyedge <= in ^ prev_in;    // Registered edge detection
    end

endmodule