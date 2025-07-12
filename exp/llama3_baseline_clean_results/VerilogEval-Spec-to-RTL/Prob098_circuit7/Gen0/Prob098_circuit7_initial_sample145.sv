module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= 0;
    end else begin
        // q stays the same as it was on the previous rising edge of clk
    end
end

endmodule