module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

reg D;

always @(*) begin
    case ({j, k})
        2'b00: D = Q;
        2'b01: D = 1'b0;
        2'b10: D = 1'b1;
        2'b11: D = ~Q;
        default: D = Q;
    endcase
end

always @(posedge clk) begin
    Q <= D;
end

endmodule