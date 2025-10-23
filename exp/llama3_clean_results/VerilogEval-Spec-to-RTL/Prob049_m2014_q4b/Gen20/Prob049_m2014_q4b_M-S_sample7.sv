module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or negedge ar) begin
    if (~ar) begin
        if (posedge clk) begin
            q <= d;
        end
    end else begin
        q = 1'b0;
    end
end

endmodule