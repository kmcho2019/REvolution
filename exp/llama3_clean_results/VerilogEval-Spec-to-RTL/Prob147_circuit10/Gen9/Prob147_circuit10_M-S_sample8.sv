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
    end else begin
        state <= ~b;
    end
end

assign q = (!a)? b : state;

endmodule