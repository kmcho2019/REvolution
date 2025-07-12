module TopModule(
    input  clock,
    input  a,
    output p,
    output q
);

reg state;

always @(posedge clock) begin
    if (a) begin
        state <= 1'b1;
    end else begin
        state <= 1'b0;
    end
end

assign p = a && clock;
assign q = state;

endmodule