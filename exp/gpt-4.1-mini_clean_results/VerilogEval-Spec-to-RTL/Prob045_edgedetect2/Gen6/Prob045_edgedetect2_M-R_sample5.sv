module TopModule (
    input clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [7:0] prev_in;

    // Update prev_in on the positive edge of clk
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Detect edges by comparing current input with previous input
    assign anyedge = in ^ prev_in;

endmodule