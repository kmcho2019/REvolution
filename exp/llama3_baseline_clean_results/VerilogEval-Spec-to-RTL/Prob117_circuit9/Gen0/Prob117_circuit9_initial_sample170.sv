module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (q == 3'b111) begin
            q <= 3'b000;
        end else begin
            q <= q + 1'b1;
        end
    end else begin
        q <= 3'b001;
    end
end

endmodule