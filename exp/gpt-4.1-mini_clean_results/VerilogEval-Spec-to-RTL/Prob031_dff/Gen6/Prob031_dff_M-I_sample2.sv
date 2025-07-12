module TopModule (
    input clk,
    input d,
    output reg q
);
    // Single positive edge triggered D flip-flop
    always @(posedge clk) begin
        q <= d;
    end
endmodule