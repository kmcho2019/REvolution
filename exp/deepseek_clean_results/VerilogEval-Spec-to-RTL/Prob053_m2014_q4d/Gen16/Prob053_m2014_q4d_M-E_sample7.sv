module TopModule (
    input clk,
    input in,
    output reg out
);

    reg out_delayed;
    wire xor_result;

    // XOR with delayed feedback
    assign xor_result = in ^ out_delayed;

    // Main flip-flop
    always @(posedge clk) begin
        out <= xor_result;
    end

    // Delayed feedback register
    always @(posedge clk) begin
        out_delayed <= out;
    end

endmodule