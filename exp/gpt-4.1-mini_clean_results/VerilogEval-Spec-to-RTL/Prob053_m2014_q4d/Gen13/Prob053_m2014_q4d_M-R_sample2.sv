module TopModule (
    input clk,
    input in,
    output reg out
);

    wire d_in;

    // Continuous assignment for combinational XOR logic
    assign d_in = in ^ out;

    // Sequential logic capturing the XOR output at rising edge of clk
    always @(posedge clk) begin
        out <= d_in;
    end

endmodule