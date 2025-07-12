module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] counter;

always_ff @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        out <= 0;
    end else begin
        if (j && !k) begin
            counter <= counter + 1;
        end else if (k) begin
            counter <= 0;
        end
        out <= (counter > 0) ? 1 : 0;
    end
end

endmodule