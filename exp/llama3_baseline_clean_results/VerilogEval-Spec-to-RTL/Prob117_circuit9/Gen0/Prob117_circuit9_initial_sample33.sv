module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @ (posedge clk) begin
    if (a == 1'b1) begin
        if (q == 3'b000) begin
            q <= 3'b100;
        end else begin
            q <= q;
        end
    end else begin
        if (q == 3'b111) begin
            q <= 3'b000;
        end else begin
            q <= q + 1;
        end
    end
end

initial begin
    q <= 3'b100;
end

endmodule