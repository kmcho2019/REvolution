module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output logic out
);

logic state;

assign out = state;

always_ff @(posedge clk) begin
    if (reset) state <= 1'b0;
    else state <= (state == 1'b0 && j) || (state == 1'b1 && !k);
end

endmodule