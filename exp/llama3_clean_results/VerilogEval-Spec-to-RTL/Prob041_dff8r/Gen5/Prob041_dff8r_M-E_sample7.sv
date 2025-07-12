module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

logic [7:0] reg_q;

always_ff @(posedge clk) begin
    if (reset) reg_q <= 8'b0;
    else reg_q <= d;
end

assign q = reg_q;

endmodule