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
    if(reset) begin
        state <= 1'b0;
    end else begin
        state <= (state == 1'b0) ? j : ~k;
    end
end

endmodule