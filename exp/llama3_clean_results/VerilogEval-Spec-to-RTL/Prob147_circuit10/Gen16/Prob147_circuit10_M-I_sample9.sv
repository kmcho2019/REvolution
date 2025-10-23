module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

always @(posedge clk) begin
    if (!a) begin
        state <= b;
    end else if (a && b) begin
        state <= ~state;
    end
end

assign q = a ^ b;

initial begin
    state = 1'b0;
end

endmodule