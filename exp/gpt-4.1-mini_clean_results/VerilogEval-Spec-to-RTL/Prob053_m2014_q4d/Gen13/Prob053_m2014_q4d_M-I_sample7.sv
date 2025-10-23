module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_in;
    assign xor_in = in ^ out;

    always @(posedge clk) begin
        out <= xor_in;
    end

    // Optional simulation-only initial block to avoid X mismatch
    // Not synthesizable, does not affect actual hardware
    // Remove if strict synthesis-only code is required
    initial begin
        out = 0;
    end

endmodule