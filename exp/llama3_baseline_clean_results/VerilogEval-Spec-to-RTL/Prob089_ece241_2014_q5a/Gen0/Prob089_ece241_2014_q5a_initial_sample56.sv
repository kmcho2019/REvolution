module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [31:0] sum;
reg flip;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        sum <= 0;
        flip <= 0;
        z <= 0;
    end else begin
        if (x && !flip) begin
            flip <= 1;
        end
        if (flip) begin
            sum <= {sum[30:0], ~x};
            if (x) begin
                sum <= sum + 1;
            end
        end else begin
            sum <= {sum[30:0], x};
        end
        z <= sum[0];
    end
end

endmodule