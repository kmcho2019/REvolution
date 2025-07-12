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
    if (reset) begin
        state <= 1'b0;
    end else if (state == 1'b0 && j == 1'b1) begin
        state <= 1'b1;
    end else if (state == 1'b1 && k == 1'b1) begin
        state <= 1'b0;
    end
end

endmodule