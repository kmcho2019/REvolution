module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (!a) begin
        state <= b;
    end else if (a &&!b) begin
        state <= 0;
    end else if (a && b) begin
        state <= 0;
    end
end

assign q = (!a)? b : state;

endmodule