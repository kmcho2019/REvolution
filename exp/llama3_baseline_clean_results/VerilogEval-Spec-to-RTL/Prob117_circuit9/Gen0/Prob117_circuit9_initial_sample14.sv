module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial begin
    q = 3'b100; // initialize q to 4
end

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // if 'a' is high, 'q' remains at 4
    end else begin
        if (q == 3'b110) begin // if 'q' is 6, reset to 0
            q <= 3'b000;
        end else begin
            q <= q + 1; // otherwise, increment 'q'
        end
    end
end

endmodule