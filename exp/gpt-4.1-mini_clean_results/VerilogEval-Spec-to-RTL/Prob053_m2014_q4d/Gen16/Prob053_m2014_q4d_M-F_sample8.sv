module TopModule (
    input clk,
    input in,
    output reg out
);

    wire xor_out;

    assign xor_out = in ^ out;

    // Initialize 'out' to 0 to avoid simulation X mismatch (no reset)
    initial begin
        out = 0;
    end

    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule