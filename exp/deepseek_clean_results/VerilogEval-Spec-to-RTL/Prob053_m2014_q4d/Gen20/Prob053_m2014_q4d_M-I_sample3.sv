module TopModule (
    input clk,
    input in,
    output reg out
);

    // DFF with XOR feedback, no reset as specified
    always @(posedge clk) begin
        out <= in ^ out;
    end

endmodule