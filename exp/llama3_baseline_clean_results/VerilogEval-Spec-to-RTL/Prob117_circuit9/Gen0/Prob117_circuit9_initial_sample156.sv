module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (q == 3'b111) begin // maximum count reached, wrap around
            q <= 3'b000;
        end else begin
            q <= q + 1'b1;
        end
    end else begin // 'a' is high, hold 'q' at 4
        q <= 3'b100;
    end
end

initial begin
    q = 3'b100; // initialize 'q' to 4
end

endmodule