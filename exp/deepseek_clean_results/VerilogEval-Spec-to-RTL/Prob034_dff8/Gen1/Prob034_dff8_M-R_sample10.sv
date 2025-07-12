module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // Implement 8 D flip-flops using always block
    always @(posedge clk) begin
        q <= d;
    end

endmodule