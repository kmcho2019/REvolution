module TopModule(
    input clk,
    input a,
    output reg q
);

always @ (posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        if (q === 1'bx) begin // x means uninitialized
            q <= 1;
        end
    end
end

endmodule