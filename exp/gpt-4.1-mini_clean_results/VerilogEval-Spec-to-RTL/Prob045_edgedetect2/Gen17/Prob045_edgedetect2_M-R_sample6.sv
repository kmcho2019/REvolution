module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    reg [7:0] prev_in;

    // Update the previous input register on the rising edge of clk
    always @(posedge clk) begin
        prev_in <= in;
    end

    // Any edge detected if current input differs from previous input (bitwise XOR)
    assign anyedge = in ^ prev_in;

endmodule