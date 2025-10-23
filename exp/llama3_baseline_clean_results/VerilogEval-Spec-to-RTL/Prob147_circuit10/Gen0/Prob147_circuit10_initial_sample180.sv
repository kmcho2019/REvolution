module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @ (posedge clk) begin
    state <= ~a & (~b | state);
    q <= (~a & b) | state;
end

endmodule