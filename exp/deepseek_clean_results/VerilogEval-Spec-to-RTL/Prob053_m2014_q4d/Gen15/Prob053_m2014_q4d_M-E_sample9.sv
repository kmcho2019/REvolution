module TopModule (
    input clk,
    input in,
    output reg out
);

    wire feedback_xor;
    reg intermediate;

    // Combinational XOR feedback path
    assign feedback_xor = in ^ out;

    // Clock-gated intermediate storage
    always @(clk or feedback_xor) begin
        if (clk) begin
            intermediate <= feedback_xor;
        end
    end

    // Final edge-triggered flip-flop
    always @(posedge clk) begin
        out <= intermediate;
    end

endmodule