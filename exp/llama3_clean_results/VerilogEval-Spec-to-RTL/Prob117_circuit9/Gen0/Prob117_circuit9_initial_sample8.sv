module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial begin
    q = 4;
end

always @(posedge clk) begin
    if (~a) begin
        q = q + 1;
        if (q == 4'd8) begin // Since q is 3 bits, its max value is 7 (2^3 - 1), but we're comparing to 8 to wrap around to 0 correctly.
            q = 0;
        end
    end
end

endmodule