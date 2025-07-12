module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] prev_in;

    // Register the previous input value on the clock's positive edge
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Combinationally compute anyedge as XOR between current and previous input
    assign anyedge = in ^ prev_in;

endmodule