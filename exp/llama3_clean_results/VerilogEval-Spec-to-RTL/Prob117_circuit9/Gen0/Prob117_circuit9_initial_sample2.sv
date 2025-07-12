module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 3'b100; // Initial value of q is 4

always @(posedge clk) begin
    if (~a) begin // If 'a' is 0, increment q
        q <= q + 1;
    end else begin // If 'a' is 1, keep q the same
        q <= q;
    end
end

endmodule