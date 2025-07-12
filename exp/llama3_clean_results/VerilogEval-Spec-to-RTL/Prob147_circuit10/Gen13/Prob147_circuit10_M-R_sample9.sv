module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

assign q = a? ~b : b;

always @(posedge clk) begin
    if (!a) begin
        state <= b;
    end else if (b) begin
        state <= ~state;
    end
end

endmodule