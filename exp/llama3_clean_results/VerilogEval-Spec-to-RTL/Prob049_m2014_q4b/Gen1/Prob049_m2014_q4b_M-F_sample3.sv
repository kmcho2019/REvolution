module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 0;
    end else if (!ar && $stable(clk)) begin
        // this condition ensures q is updated only on the rising edge of clk
        // when ar is not asserted
        if (clk) begin
            q <= d;
        end
    end else begin
        // additional condition to make sure the value of q doesn't change
        // on the falling edge of clk when ar is not asserted
        q <= q;
    end
end

endmodule