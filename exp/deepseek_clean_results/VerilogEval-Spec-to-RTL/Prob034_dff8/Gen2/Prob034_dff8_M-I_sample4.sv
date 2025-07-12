module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // Using single always block with non-blocking assignment
    // This is optimal for modern synthesis tools to infer efficient flip-flops
    always @(posedge clk) begin
        q <= d;
    end

endmodule