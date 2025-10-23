module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

initial state = 1'b0;

always @(posedge clk) begin
    if (a == 1'b1 && b == 1'b1) begin
        state <= 1'b0;
    end else if (a == 1'b0 && b == 1'b1) begin
        state <= 1'b1;
    end else begin
        state <= state;
    end
end

assign q = (a == 1'b1 && b == 1'b0) || (state == 1'b1 && (b == 1'b1 || a == 1'b0));

endmodule