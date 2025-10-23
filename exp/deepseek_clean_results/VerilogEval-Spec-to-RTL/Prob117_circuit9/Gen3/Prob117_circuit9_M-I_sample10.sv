module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'b100
);

always @(posedge clk) begin
    if (!a) begin
        if (q == 3'b110)
            q <= 3'b000;
        else
            q <= q + 1;
    end
    else begin
        q <= q;  // maintain value when a is high
    end
end

endmodule