module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (a == 1'b0 && b == 1'b1) begin
        state <= 1'b1;
    end else if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0;
    end else if (a == 1'b0 && b == 1'b0) begin
        state <= 1'b0;
    end
end

assign q = (state == 1'b1) || (a == 1'b1 && b == 1'b0);

endmodule