module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);
    // 8-bit register with positive edge clock triggering all flip-flops simultaneously
    always @(posedge clk) begin
        q <= d;
    end
endmodule