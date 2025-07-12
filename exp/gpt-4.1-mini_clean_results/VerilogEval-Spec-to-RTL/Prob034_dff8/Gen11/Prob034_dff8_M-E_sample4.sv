module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    reg [2:0] bit_index;

    always @(posedge clk) begin
        // Shift q left by 1, inserting d[bit_index] into LSB
        q <= {q[6:0], d[bit_index]};
        // Increment bit_index modulo 8
        bit_index <= bit_index + 1;
    end

    // Initialize outputs to zero
    initial begin
        q = 8'b0;
        bit_index = 3'd0;
    end
endmodule