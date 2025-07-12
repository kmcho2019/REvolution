module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        q <= q + 1'b1;  // Automatic wrap-around from 9 to 0
    end
end

endmodule