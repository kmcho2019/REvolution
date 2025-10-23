module TopModule (
    input clk,
    input in,
    output reg out
);

    reg xor_in;

    // Combinational XOR of input and previous output
    always @(*) begin
        xor_in = in ^ out;
    end

    // D flip-flop updates output at posedge clk with XOR result
    always @(posedge clk) begin
        out <= xor_in;
    end

endmodule